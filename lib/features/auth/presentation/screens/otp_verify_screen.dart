import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  final String role;

  /// Server-provided cool-down. The countdown is cosmetic: the backend rejects
  /// an early resend regardless of the device clock.
  final int resendAfterSeconds;

  /// Digits the provider issued (UDO = 5), straight from `POST /auth/otp/send`.
  final int codeLength;

  const OtpVerifyScreen({
    super.key,
    required this.phone,
    required this.role,
    this.resendAfterSeconds = 30,
    this.codeLength = 5,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late final List<TextEditingController> _controllers = List.generate(
    widget.codeLength,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes =
      List.generate(widget.codeLength, (_) => FocusNode());

  Timer? _resendTimer;
  int _secondsUntilResend = 0;

  @override
  void initState() {
    super.initState();
    _startResendCountdown(widget.resendAfterSeconds, notify: false);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown(int seconds, {bool notify = true}) {
    _resendTimer?.cancel();
    void apply() => _secondsUntilResend = seconds < 0 ? 0 : seconds;
    if (notify) {
      setState(apply);
    } else {
      apply();
    }
    if (_secondsUntilResend == 0) return;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _secondsUntilResend -= 1);
      if (_secondsUntilResend <= 0) timer.cancel();
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _submit(BuildContext context) {
    final otp = _otp;
    final l10n = AppLocalizations.of(context)!;
    if (otp.length != widget.codeLength) {
      AppToast.show(
        context,
        l10n.enterAllDigits(widget.codeLength),
        type: ToastType.warning,
      );
      return;
    }
    context.read<AuthBloc>().add(
      AuthOtpVerifyRequested(phone: widget.phone, otp: otp, role: widget.role),
    );
  }

  void _resend(BuildContext context) {
    if (_secondsUntilResend > 0) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    context.read<AuthBloc>().add(AuthOtpSendRequested(phone: widget.phone));
  }

  /// Clears every box (used when the challenge is no longer usable).
  void _clearDigits() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  /// Shows the failure and reacts to the *code*, not to the prose.
  void _handleError(AuthError state) {
    final code = state.code;
    AppToast.show(context, state.message, type: ToastType.error);

    // A wrong code is worth retrying with the same challenge: keep the boxes but
    // clear them so the user can retype. A locked/expired challenge cannot be
    // retried at all, so the input is cleared and the user must resend.
    if (code == null || code == 'OTP_INVALID' || code == 'OTP_EXPIRED' || code == 'OTP_LOCKED') {
      _clearDigits();
    }

    if (code == 'OTP_COOLDOWN' || code == 'OTP_RATE_LIMITED' || code == 'OTP_LOCKED') {
      _startResendCountdown(state.retryAfterSeconds ?? 30);
    }
  }

  Widget _buildDigitBox(BuildContext context, int index) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[index].text.isEmpty &&
            index > 0) {
          _controllers[index - 1].clear();
          _focusNodes[index - 1].requestFocus();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 52,
          height: 60,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTypography.h2.copyWith(color: cs.onSurface),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) => _onDigitChanged(index, v),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isVendor = widget.role == 'vendor';
    final roleColor = isVendor ? AppColors.primary : AppColors.customerAccent;
    final roleLabel = isVendor ? l10n.vendor : l10n.customer;
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerifiedNewUser) {
          context.push(
            AppRouter.profileSetup,
            extra: {'signupToken': state.signupToken, 'phone': state.phone},
          );
        } else if (state is AuthOtpSent) {
          // A resend restarts the server-provided cool-down.
          _startResendCountdown(state.resendAfterSeconds);
        } else if (state is AuthError) {
          _handleError(state);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      roleLabel,
                      style: AppTypography.bodySmall.copyWith(
                        color: roleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.enterOtpTitle,
                    style: AppTypography.h1.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: '${l10n.sentToLabel}  ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: '+91 ${widget.phone}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Large square OTP boxes — one per digit issued by the provider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (i) => _buildDigitBox(context, i),
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: l10n.verifyButton,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: (isLoading || _secondsUntilResend > 0)
                          ? null
                          : () => _resend(context),
                      child: RichText(
                        text: TextSpan(
                          text: "${l10n.noOtpReceived}  ",
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              // The countdown comes from the server's cooldown,
                              // so changing the device clock bypasses nothing.
                              text: _secondsUntilResend > 0
                                  ? '${l10n.resendOtp} (${_secondsUntilResend}s)'
                                  : l10n.resendOtp,
                              style: AppTypography.bodySmall.copyWith(
                                color: _secondsUntilResend > 0
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
