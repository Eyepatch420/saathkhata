import 'package:equatable/equatable.dart';
import '../../../../shared/models/link_model.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

enum RemindAllStatus { idle, loading, success, failure }

class VendorLoaded extends VendorState {
  final List<CustomerLinkItem> customers;
  final List<VendorLinkItem> myVendors;
  final double totalOutstanding;
  final double todayCollection;
  final RemindAllStatus remindAllStatus;
  final int remindAllQueued;

  const VendorLoaded({
    required this.customers,
    required this.myVendors,
    required this.totalOutstanding,
    required this.todayCollection,
    this.remindAllStatus = RemindAllStatus.idle,
    this.remindAllQueued = 0,
  });

  VendorLoaded copyWith({
    List<CustomerLinkItem>? customers,
    List<VendorLinkItem>? myVendors,
    double? totalOutstanding,
    double? todayCollection,
    RemindAllStatus? remindAllStatus,
    int? remindAllQueued,
  }) =>
      VendorLoaded(
        customers: customers ?? this.customers,
        myVendors: myVendors ?? this.myVendors,
        totalOutstanding: totalOutstanding ?? this.totalOutstanding,
        todayCollection: todayCollection ?? this.todayCollection,
        remindAllStatus: remindAllStatus ?? this.remindAllStatus,
        remindAllQueued: remindAllQueued ?? this.remindAllQueued,
      );

  @override
  List<Object?> get props =>
      [customers, myVendors, totalOutstanding, todayCollection, remindAllStatus, remindAllQueued];
}

class VendorError extends VendorState {
  final String message;

  const VendorError(this.message);

  @override
  List<Object?> get props => [message];
}
