import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../shared/models/order_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repo;

  OrderBloc(this._repo) : super(const OrderInitial()) {
    on<LoadVendorOrders>(_onLoadVendorOrders);
    on<LoadCustomerOrders>(_onLoadCustomerOrders);
    on<LoadStaffOrders>(_onLoadStaffOrders);
    on<PlaceOrder>(_onPlaceOrder);
    on<PlaceOrderForCustomer>(_onPlaceOrderForCustomer);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadVendorOrders(
    LoadVendorOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final result = await _repo.getVendorOrders(
        status: event.statusFilter,
        linkId: event.linkId,
      );
      emit(OrderLoaded(orders: result.orders, pending: result.pending));
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadCustomerOrders(
    LoadCustomerOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final result = await _repo.getCustomerOrders();
      emit(OrderLoaded(orders: result.orders, pending: result.pending));
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadStaffOrders(
    LoadStaffOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final result = await _repo.getStaffOrders();
      emit(OrderLoaded(orders: result.orders, pending: result.pending));
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    final current = state;
    final currentOrders = current is OrderLoaded ? current.orders : <Order>[];
    final currentPending = current is OrderLoaded ? current.pending : 0;

    emit(OrderActionLoading(orders: currentOrders, pending: currentPending));
    try {
      final order = await _repo.placeOrder(
        linkId: event.linkId,
        items: event.items,
        note: event.note,
      );
      final updated = [order, ...currentOrders];
      emit(
        OrderPlaced(order: order, orders: updated, pending: currentPending + 1),
      );
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onPlaceOrderForCustomer(
    PlaceOrderForCustomer event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    final currentOrders = current is OrderLoaded ? current.orders : <Order>[];
    final currentPending = current is OrderLoaded ? current.pending : 0;

    emit(OrderActionLoading(orders: currentOrders, pending: currentPending));
    try {
      final order = await _repo.placeOrderForCustomer(
        linkId: event.linkId,
        items: event.items,
        note: event.note,
      );
      final updated = [order, ...currentOrders];
      emit(
        OrderPlaced(order: order, orders: updated, pending: currentPending + 1),
      );
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    final currentOrders = current is OrderLoaded ? current.orders : <Order>[];
    final currentPending = current is OrderLoaded ? current.pending : 0;

    emit(OrderActionLoading(orders: currentOrders, pending: currentPending));
    try {
      final updated = await _repo.updateOrderStatus(
        event.orderId,
        event.status,
        deliveryNote: event.deliveryNote,
        proofUrl: event.proofUrl,
      );
      final newOrders = currentOrders
          .map((o) => o.id == event.orderId ? updated : o)
          .toList();
      final newPending = newOrders
          .where((o) => o.status == OrderStatus.pending)
          .length;
      emit(OrderLoaded(orders: newOrders, pending: newPending));
    } catch (e) {
      emit(OrderError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
