/// Production-grade payment verification contract.
///
/// The mock implementation uses simulated delays and random outcomes.
/// Replace with Razorpay / UPI-intent polling when integrating real payments.
abstract class PaymentVerificationService {
  /// Verify whether a payment with [transactionRef] actually completed.
  ///
  /// [transactionRef] – a client-generated idempotency key (timestamp-based).
  /// [amount]         – the amount that was supposed to be paid (in INR).
  /// [recipientUpiId] – UPI ID of the payee (for cross-checking).
  Future<PaymentVerificationResult> verify({
    required String transactionRef,
    required double amount,
    required String recipientUpiId,
  });
}

// ─── Result types ─────────────────────────────────────────────────────────────

enum PaymentVerificationStatus {
  /// Bank confirmed the debit and credit.
  verified,

  /// Payment was declined or failed at the bank.
  failed,

  /// We could not confirm within the timeout window — needs manual follow-up.
  timeout,

  /// Status is indeterminate (network error, service unavailable).
  unknown,
}

class PaymentVerificationResult {
  final PaymentVerificationStatus status;

  /// Set only when [status] == [PaymentVerificationStatus.verified].
  final String? verifiedTransactionId;

  /// Human-readable reason set when [status] is [failed] or [unknown].
  final String? failureReason;

  const PaymentVerificationResult({
    required this.status,
    this.verifiedTransactionId,
    this.failureReason,
  });

  bool get isVerified => status == PaymentVerificationStatus.verified;
}
