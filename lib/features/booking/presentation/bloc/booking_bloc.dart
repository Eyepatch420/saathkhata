import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../shared/models/booking_model.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../../../core/utils/app_logger.dart';

String _toDateString(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  static const _m = 'Booking';

  BookingBloc(this._repository) : super(BookingInitial()) {
    on<LoadVendorBookings>(_onLoadVendor);
    on<LoadCustomerBookings>(_onLoadCustomer);
    on<LoadAvailableSlots>(_onLoadSlots);
    on<CreateBooking>(_onCreate);
    on<CancelBooking>(_onCancel);
    on<UpdateBookingStatus>(_onUpdateStatus);
    on<SelectBookingDate>(_onSelectDate);
    on<LoadBookingConfig>(_onLoadConfig);
    on<SaveBookingConfig>(_onSaveConfig);
    on<ToggleSlotFull>(_onToggleSlotFull);
    on<LoadDateSlots>(_onLoadDateSlots);
    on<SaveDateSlots>(_onSaveDateSlots);
    on<SetDateClosed>(_onSetDateClosed);
    on<DeleteDateSlots>(_onDeleteDateSlots);
    on<ReplicateSlots>(_onReplicateSlots);
    on<MergeSlots>(_onMergeSlots);
  }

  Future<void> _onLoadVendor(LoadVendorBookings event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Loading vendor bookings for date:${_toDateString(event.date)}');
    emit(BookingLoading());
    try {
      final bookings = await _repository.getVendorBookings(_toDateString(event.date));
      emit(BookingLoaded(bookings: bookings, selectedDate: event.date));
    } catch (e) {
      AppLogger.e(_m, 'Load vendor bookings failed', e);
      emit(const BookingError('Failed to load bookings'));
    }
  }

  Future<void> _onLoadCustomer(LoadCustomerBookings event, Emitter<BookingState> emit) async {
    // This is polled every 15s while the bookings screen is open (see
    // CustomerBookingsScreen). Only show the full-screen spinner on the
    // first load — a silent poll must not blank the list out from under
    // the user just to redraw the same data.
    final current = state;
    final hadData = current is BookingLoaded;
    AppLogger.i(_m, 'Loading customer bookings...');
    if (!hadData) emit(BookingLoading());
    try {
      final bookings = await _repository.getCustomerBookings();
      // Reuse the previous selectedDate rather than stamping DateTime.now()
      // on every poll tick — otherwise the state is never equal to the
      // last one even when the booking list itself hasn't changed, forcing
      // a rebuild every 15s for no visible reason.
      final selectedDate = hadData ? current.selectedDate : DateTime.now();
      emit(BookingLoaded(bookings: bookings, selectedDate: selectedDate));
    } catch (e) {
      AppLogger.e(_m, 'Load customer bookings failed', e);
      if (!hadData) emit(const BookingError('Failed to load bookings'));
    }
  }

  Future<void> _onLoadSlots(LoadAvailableSlots event, Emitter<BookingState> emit) async {
    final dateStr = _toDateString(event.date);
    AppLogger.i(_m, 'Loading slots — vendorId:${event.vendorId} date:$dateStr');
    emit(BookingLoading());
    try {
      // Fetch slots and customer's existing bookings concurrently
      final results = await Future.wait([
        _repository.getAvailableSlots(event.vendorId, dateStr),
        _repository.getCustomerBookings(),
      ]);

      final slots = results[0] as List<AppointmentSlot>;
      final myBookings = results[1] as List<BookingModel>;

      // Find start times the customer already has active on this vendor+date
      final bookedTimes = myBookings
          .where((b) =>
              b.vendorId == event.vendorId &&
              b.date == dateStr &&
              (b.status == BookingStatus.pending || b.status == BookingStatus.confirmed))
          .map((b) => b.startTime)
          .toSet();

      final markedSlots = bookedTimes.isEmpty
          ? slots
          : slots
              .map((s) => bookedTimes.contains(s.startTime) ? s.copyWith(isAlreadyBooked: true) : s)
              .toList();

      emit(SlotsLoaded(slots: markedSlots, date: event.date));
    } catch (e) {
      AppLogger.e(_m, 'Load slots failed', e);
      emit(const BookingError('Failed to load slots'));
    }
  }

  Future<void> _onCreate(CreateBooking event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Creating booking — vendorId:${event.booking.vendorId} date:${event.booking.date}');
    // Remember slot state so we can restore it on failure
    final prevState = state;
    emit(BookingLoading());
    try {
      final booking = await _repository.createBooking(event.booking);
      emit(BookingCreated(booking));
    } catch (e) {
      AppLogger.e(_m, 'Create booking failed', e);
      final msg = e.toString().replaceFirst('Exception: ', '');
      // Restore the slot grid on failure so the user can still see the screen
      if (prevState is SlotsLoaded) {
        emit(BookingCreateError(
          slots: prevState.slots,
          date: prevState.date,
          message: msg,
        ));
      } else {
        emit(BookingError(msg));
      }
    }
  }

  Future<void> _onCancel(CancelBooking event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Cancelling booking id:${event.bookingId}');
    try {
      await _repository.updateBookingStatus(event.bookingId, BookingStatus.cancelled);
      add(LoadCustomerBookings());
    } catch (e) {
      AppLogger.e(_m, 'Cancel booking failed id:${event.bookingId}', e);
    }
  }

  Future<void> _onUpdateStatus(UpdateBookingStatus event, Emitter<BookingState> emit) async {
    final current = state;
    if (current is! BookingLoaded) return;

    AppLogger.i(_m, 'Updating booking id:${event.bookingId} → ${event.status.name}');

    final optimistic = current.bookings
        .map((b) => b.id == event.bookingId ? b.copyWith(status: event.status) : b)
        .toList();
    emit(current.copyWith(bookings: optimistic));

    try {
      final updated = await _repository.updateBookingStatus(event.bookingId, event.status);
      final confirmed = current.bookings
          .map((b) => b.id == updated.id ? updated : b)
          .toList();
      emit(current.copyWith(bookings: confirmed));
    } catch (e) {
      AppLogger.e(_m, 'Booking status update failed — reverting', e);
      emit(BookingActionError(
        bookings: current.bookings,
        selectedDate: current.selectedDate,
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onSelectDate(SelectBookingDate event, Emitter<BookingState> emit) {
    AppLogger.v(_m, 'Date selected: ${_toDateString(event.date)}');
    add(LoadVendorBookings(event.date));
  }

  // ─── Config handlers ─────────────────────────────────────────────────────────

  Future<void> _onLoadConfig(LoadBookingConfig event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Loading booking config');
    emit(BookingConfigLoading());
    try {
      final config = await _repository.getBookingConfig();
      emit(BookingConfigLoaded(config ?? BookingConfig.empty()));
    } catch (e) {
      AppLogger.e(_m, 'Load booking config failed', e);
      emit(const BookingConfigError('Failed to load schedule'));
    }
  }

  Future<void> _onSaveConfig(SaveBookingConfig event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Saving booking config');
    emit(BookingConfigLoading());
    try {
      final saved = await _repository.saveBookingConfig(event.config);
      emit(BookingConfigSaved(saved));
    } catch (e) {
      AppLogger.e(_m, 'Save booking config failed', e);
      emit(BookingConfigError(
        e.toString().replaceFirst('Exception: ', ''),
        config: event.config,
      ));
    }
  }

  Future<void> _onToggleSlotFull(ToggleSlotFull event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Toggle slot full day:${event.dayOfWeek} time:${event.startTime} full:${event.isFull}');

    // Keep the current config visible while updating
    final current = state;
    final currentConfig = current is BookingConfigLoaded ? current.config : null;

    try {
      final updated = await _repository.toggleSlotFull(
        dayOfWeek: event.dayOfWeek,
        startTime: event.startTime,
        isFull: event.isFull,
      );
      emit(BookingConfigLoaded(updated));
    } catch (e) {
      AppLogger.e(_m, 'Toggle slot full failed', e);
      emit(BookingConfigError(
        e.toString().replaceFirst('Exception: ', ''),
        config: currentConfig,
      ));
    }
  }

  // ─── Per-date override handlers ──────────────────────────────────────────────

  Future<void> _onLoadDateSlots(LoadDateSlots event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Loading date slots for ${event.date}');
    emit(DateSlotsLoading());
    try {
      final override = await _repository.getDateSlots(event.date);
      emit(DateSlotsLoaded(override));
    } catch (e) {
      AppLogger.e(_m, 'Load date slots failed', e);
      emit(DateSlotsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSaveDateSlots(SaveDateSlots event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Saving date slots for ${event.date}');
    emit(DateSlotsLoading());
    try {
      final saved = await _repository.saveDateSlots(event.date, event.slots);
      emit(DateSlotsSaved(saved));
    } catch (e) {
      AppLogger.e(_m, 'Save date slots failed', e);
      emit(DateSlotsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSetDateClosed(SetDateClosed event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Setting date closed=${event.closed} for ${event.date}');
    emit(DateSlotsLoading());
    try {
      final updated = await _repository.setDateClosed(event.date, event.closed);
      emit(DateSlotsSaved(updated));
    } catch (e) {
      AppLogger.e(_m, 'Set date closed failed', e);
      emit(DateSlotsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDeleteDateSlots(DeleteDateSlots event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Reverting date slots to template for ${event.date}');
    emit(DateSlotsLoading());
    try {
      final reverted = await _repository.deleteDateSlots(event.date);
      emit(DateSlotsSaved(reverted));
    } catch (e) {
      AppLogger.e(_m, 'Delete date slots failed', e);
      emit(DateSlotsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onReplicateSlots(ReplicateSlots event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Replicating slots targetType:${event.targetType} startDate:${event.startDate}');
    try {
      final result = await _repository.replicateSlots(
        sourceDate: event.sourceDate,
        sourceDayOfWeek: event.sourceDayOfWeek,
        targetType: event.targetType,
        startDate: event.startDate,
        monthsCount: event.monthsCount,
      );
      emit(ReplicateCompleted(result));
    } catch (e) {
      AppLogger.e(_m, 'Replicate slots failed', e);
      emit(ReplicateError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onMergeSlots(MergeSlots event, Emitter<BookingState> emit) async {
    AppLogger.i(_m, 'Merging slots indexes:${event.slotIndexes}');
    try {
      final merged = await _repository.mergeSlots(
        date: event.date,
        dayOfWeek: event.dayOfWeek,
        slotIndexes: event.slotIndexes,
        mergedCapacity: event.mergedCapacity,
      );
      emit(SlotsMerged(merged));
    } catch (e) {
      AppLogger.e(_m, 'Merge slots failed', e);
      emit(MergeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
