import 'dart:math';
import '../../domain/services/payment_verification_service.dart';

/// Mock payment verification — simulates real bank polling behaviour.
///
/// Characteristics:
/// - Random delay between 3 and 8 seconds (mimics network + bank latency).
/// - 85 % success rate, 10 % failure, 5 % unknown (realistic for testing).
/// - Generates a deterministic fake transaction ID on success.
///
/// Replace with:
///   • Razorpay `order_id` polling via `/v1/orders/{id}/payments`
///   • UPI intent `Activity.onActivityResult` status check
class MockPaymentVerificationService implements PaymentVerificationService {
  final Random _rng;

  MockPaymentVerificationService([Random? rng]) : _rng = rng ?? Random();

  @override
  Future<PaymentVerificationResult> verify({
    required String transactionRef,
    required double amount,
    required String recipientUpiId,
  }) async {
    // Simulate bank round-trip: 3–8 s
    final delayMs = 3000 + _rng.nextInt(5001);
    await Future<void>.delayed(Duration(milliseconds: delayMs));

    final roll = _rng.nextDouble(); // 0.0 – 1.0

    if (roll < 0.85) {
      // SUCCESS — 85 %
      final txnId =
          'TXN${DateTime.now().millisecondsSinceEpoch}_${transactionRef.substring(0, min(6, transactionRef.length))}';
      return PaymentVerificationResult(
        status: PaymentVerificationStatus.verified,
        verifiedTransactionId: txnId,
      );
    } else if (roll < 0.95) {
      // FAILURE — 10 %
      return const PaymentVerificationResult(
        status: PaymentVerificationStatus.failed,
        failureReason:
            'Payment was declined by your bank. Please check your account balance and try again.',
      );
    } else {
      // UNKNOWN — 5 %
      return const PaymentVerificationResult(
        status: PaymentVerificationStatus.unknown,
        failureReason:
            'Could not reach payment network. Your money has NOT been debited.',
      );
    }
  }
}
