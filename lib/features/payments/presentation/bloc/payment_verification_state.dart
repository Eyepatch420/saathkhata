import 'package:equatable/equatable.dart';

abstract class PaymentVerificationState extends Equatable {
  const PaymentVerificationState();
  @override
  List<Object?> get props => [];
}

class PaymentVerificationInitial extends PaymentVerificationState {}

class PaymentVerificationInProgress extends PaymentVerificationState {
  const PaymentVerificationInProgress();
}

class PaymentVerificationSuccess extends PaymentVerificationState {
  final String transactionId;
  final double amount;
  final String recipientName;

  const PaymentVerificationSuccess({
    required this.transactionId,
    required this.amount,
    required this.recipientName,
  });

  @override
  List<Object?> get props => [transactionId, amount, recipientName];
}

class PaymentVerificationFailed extends PaymentVerificationState {
  final String reason;
  const PaymentVerificationFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}

/// The verification service did not respond within the timeout window.
class PaymentVerificationTimeout extends PaymentVerificationState {
  const PaymentVerificationTimeout();
}
