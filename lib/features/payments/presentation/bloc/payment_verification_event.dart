import 'package:equatable/equatable.dart';

abstract class PaymentVerificationEvent extends Equatable {
  const PaymentVerificationEvent();
  @override
  List<Object?> get props => [];
}

class StartPaymentVerification extends PaymentVerificationEvent {
  final String transactionRef;
  final double amount;
  final String recipientUpiId;
  final String recipientName;

  const StartPaymentVerification({
    required this.transactionRef,
    required this.amount,
    required this.recipientUpiId,
    required this.recipientName,
  });

  @override
  List<Object?> get props =>
      [transactionRef, amount, recipientUpiId, recipientName];
}

class RetryPaymentVerification extends PaymentVerificationEvent {
  const RetryPaymentVerification();
}

