import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/payment_verification_bloc.dart';
import '../bloc/payment_verification_event.dart';
import '../bloc/payment_verification_state.dart';

class PaymentVerificationScreen extends StatelessWidget {
  final double amount;
  final String recipientName;
  final String recipientUpiId;

  const PaymentVerificationScreen({
    super.key,
    required this.amount,
    required this.recipientName,
    required this.recipientUpiId,
  });

  @override
  Widget build(BuildContext context) {
    final transactionRef =
        'TXN_${DateTime.now().millisecondsSinceEpoch}';

    return BlocProvider(
      create: (_) => PaymentVerificationBloc(getIt())
        ..add(StartPaymentVerification(
          transactionRef: transactionRef,
          amount: amount,
          recipientUpiId: recipientUpiId,
          recipientName: recipientName,
        )),
      child: _VerificationView(
        amount: amount,
        recipientName: recipientName,
        recipientUpiId: recipientUpiId,
      ),
    );
  }
}

// ─── Main view ────────────────────────────────────────────────────────────────

class _VerificationView extends StatelessWidget {
  final double amount;
  final String recipientName;
  final String recipientUpiId;

  const _VerificationView({
    required this.amount,
    required this.recipientName,
    required this.recipientUpiId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No back button while verifying — prevent accidental exit
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.paymentVerification),
        centerTitle: true,
      ),
      body: BlocConsumer<PaymentVerificationBloc, PaymentVerificationState>(
        listener: (context, state) {
          // Nothing needed in listener — all UI is driven by builder.
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: switch (state) {
              PaymentVerificationInProgress() => _InProgressBody(
                  key: const ValueKey('progress'),
                  amount: amount,
                  recipientName: recipientName,
                ),
              PaymentVerificationSuccess s => _SuccessBody(
                  key: const ValueKey('success'),
                  state: s,
                ),
              PaymentVerificationFailed s => _FailedBody(
                  key: const ValueKey('failed'),
                  state: s,
                  recipientName: recipientName,
                  recipientUpiId: recipientUpiId,
                  amount: amount,
                ),
              PaymentVerificationTimeout() => _TimeoutBody(
                  key: const ValueKey('timeout'),
                  recipientName: recipientName,
                  recipientUpiId: recipientUpiId,
                  amount: amount,
                ),
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}

// ─── In-progress body ─────────────────────────────────────────────────────────

class _InProgressBody extends StatefulWidget {
  final double amount;
  final String recipientName;

  const _InProgressBody({
    super.key,
    required this.amount,
    required this.recipientName,
  });

  @override
  State<_InProgressBody> createState() => _InProgressBodyState();
}

class _InProgressBodyState extends State<_InProgressBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _ticker;
  int _elapsed = 0;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed++);
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = [
      l10n.verificationConnecting,
      l10n.verificationVerifying,
      l10n.verificationWaiting,
      l10n.verificationAlmostThere,
    ];
    final msg = messages[(_elapsed ~/ 4).clamp(0, messages.length - 1)];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing ring
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final scale = 1.0 + _pulse.value * 0.15;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.12),
                      border: Border.all(
                          color: AppColors.primary.withValues(
                              alpha: 0.4 + _pulse.value * 0.4),
                          width: 2),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.primary,
                      size: 44,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(l10n.verifyingPayment,
                style: AppTypography.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(msg,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            // Amount chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '₹${widget.amount.toStringAsFixed(0)}  →  ${widget.recipientName}',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            LinearProgressIndicator(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.verificationElapsed(_elapsed),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Success body ─────────────────────────────────────────────────────────────

class _SuccessBody extends StatefulWidget {
  final PaymentVerificationSuccess state;
  const _SuccessBody({super.key, required this.state});

  @override
  State<_SuccessBody> createState() => _SuccessBodyState();
}

class _SuccessBodyState extends State<_SuccessBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _enter, curve: Curves.elasticOut);
    _enter.forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 52),
              ),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.paymentConfirmedExclamation,
                style: AppTypography.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.paidToRecipient(
                  widget.state.amount.toStringAsFixed(0), widget.state.recipientName),
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLocalizations.of(context)!.txnLabel(widget.state.transactionId),
                style: AppTypography.bodySmall.copyWith(
                    color: AppColors.success, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppLocalizations.of(context)!.done,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Failed body ──────────────────────────────────────────────────────────────

class _FailedBody extends StatelessWidget {
  final PaymentVerificationFailed state;
  final String recipientName;
  final String recipientUpiId;
  final double amount;

  const _FailedBody({
    super.key,
    required this.state,
    required this.recipientName,
    required this.recipientUpiId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 52),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.paymentFailed,
                style: AppTypography.h2.copyWith(color: AppColors.error),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              state.reason,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<PaymentVerificationBloc>()
                        .add(const RetryPaymentVerification()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLocalizations.of(context)!.retryPayment,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Timeout body ─────────────────────────────────────────────────────────────

class _TimeoutBody extends StatelessWidget {
  final String recipientName;
  final String recipientUpiId;
  final double amount;

  const _TimeoutBody({
    super.key,
    required this.recipientName,
    required this.recipientUpiId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time_rounded,
                  color: AppColors.warning, size: 52),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.verificationTimedOut,
                style: AppTypography.h2, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.verificationTimeoutBody,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Advisory chip
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.ifDebitedContactSupport,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLocalizations.of(context)!.goBack),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<PaymentVerificationBloc>()
                        .add(const RetryPaymentVerification()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLocalizations.of(context)!.tryAgain,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
