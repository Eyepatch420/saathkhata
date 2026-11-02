import 'package:equatable/equatable.dart';
import '../../../../shared/models/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  final int pending;

  const OrderLoaded({required this.orders, required this.pending});

  @override
  List<Object?> get props => [orders, pending];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderActionLoading extends OrderState {
  final List<Order> orders;
  final int pending;
  const OrderActionLoading({required this.orders, required this.pending});
  @override
  List<Object?> get props => [orders, pending];
}

class OrderPlaced extends OrderState {
  final Order order;
  final List<Order> orders;
  final int pending;
  const OrderPlaced({required this.order, required this.orders, required this.pending});
  @override
  List<Object?> get props => [order, orders, pending];
}
