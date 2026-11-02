import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/payment_verification_service.dart';
import 'payment_verification_event.dart';
import 'payment_verification_state.dart';

/// Internal timeout sentinel — lives in this file so it can be private.
class _TimedOut extends PaymentVerificationEvent {
  const _TimedOut();
}

class PaymentVerificationBloc
    extends Bloc<PaymentVerificationEvent, PaymentVerificationState> {
  final PaymentVerificationService _service;

  static const _timeoutDuration = Duration(seconds: 30);

  Timer? _timeoutTimer;

  // Stored for retry
  StartPaymentVerification? _lastRequest;

  PaymentVerificationBloc(this._service)
      : super(PaymentVerificationInitial()) {
    on<StartPaymentVerification>(_onStart);
    on<RetryPaymentVerification>(_onRetry);
    on<_TimedOut>(_onTimeout);
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onStart(
    StartPaymentVerification event,
    Emitter<PaymentVerificationState> emit,
  ) async {
    _lastRequest = event;
    _cancelTimeout();

    emit(const PaymentVerificationInProgress());

    // Start timeout watchdog — fires _TimedOut if service takes too long.
    _timeoutTimer = Timer(_timeoutDuration, () {
      if (!isClosed) add(const _TimedOut());
    });

    try {
      final result = await _service.verify(
        transactionRef: event.transactionRef,
        amount: event.amount,
        recipientUpiId: event.recipientUpiId,
      );

      // Cancel watchdog — service responded in time.
      _cancelTimeout();

      // Guard: don't overwrite a Timeout state that was already emitted
      // if the service returned just after the 30s mark.
      if (state is! PaymentVerificationInProgress) return;

      if (result.status == PaymentVerificationStatus.verified) {
        emit(PaymentVerificationSuccess(
          transactionId: result.verifiedTransactionId!,
          amount: event.amount,
          recipientName: event.recipientName,
        ));
      } else if (result.status == PaymentVerificationStatus.failed) {
        emit(PaymentVerificationFailed(
          result.failureReason ??
              'Payment was not successful. Please try again.',
        ));
      } else {
        // unknown / indeterminate
        emit(PaymentVerificationFailed(
          result.failureReason ??
              'Payment status could not be confirmed. '
                  'Please check with your bank.',
        ));
      }
    } catch (e) {
      _cancelTimeout();
      if (state is PaymentVerificationInProgress) {
        emit(PaymentVerificationFailed(
            'Verification error. Please try again.'));
      }
    }
  }

  void _onRetry(
    RetryPaymentVerification event,
    Emitter<PaymentVerificationState> emit,
  ) {
    final last = _lastRequest;
    if (last == null) return;
    add(StartPaymentVerification(
      transactionRef:
          'RETRY_${DateTime.now().millisecondsSinceEpoch}',
      amount: last.amount,
      recipientUpiId: last.recipientUpiId,
      recipientName: last.recipientName,
    ));
  }

  void _onTimeout(
    _TimedOut event,
    Emitter<PaymentVerificationState> emit,
  ) {
    if (state is PaymentVerificationInProgress) {
      emit(const PaymentVerificationTimeout());
    }
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimeout();
    return super.close();
  }
}
