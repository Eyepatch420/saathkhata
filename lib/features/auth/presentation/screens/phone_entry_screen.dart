import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/otp_send_origin.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class PhoneEntryScreen extends StatefulWidget {
  final String role;
  const PhoneEntryScreen({super.key, required this.role});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _phoneController = TextEditingController();

  /// Set while the OTP route is on top. A second `AuthOtpSent` can never open a
  /// second OTP screen (the app-scoped bloc is shared by every live route).
  bool _isOpeningOtp = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// True when this screen is the visible route. Without this guard a screen
  /// buried under the OTP route would react to events that belong to it.
  bool get _isCurrentRoute => ModalRoute.of(context)?.isCurrent ?? false;

  void _submit(BuildContext context) {
    // Strip anything a keyboard, paste or autofill may have added: the API only
    // accepts the canonical 10 digits, never `+91`, spaces or a trunk zero.
    final phone = normalizeIndianPhone(_phoneController.text);
    final l10n = AppLocalizations.of(context)!;
    if (!isValidIndianPhone(phone)) {
      AppToast.show(context, l10n.invalidPhoneNumber, type: ToastType.warning);
      return;
    }
    context.read<AuthBloc>().add(AuthOtpSendRequested(phone: phone));
  }

  /// Navigates to the OTP screen exactly once per successful first send.
  Future<void> _openOtpScreen(AuthOtpSent state) async {
    if (!mounted || _isOpeningOtp || !_isCurrentRoute) return;
    _isOpeningOtp = true;
    await context.push(
      AppRouter.otpVerify,
      extra: {
        'phone': state.phone,
        'role': widget.role,
        'resendAfterSeconds': state.resendAfterSeconds,
        'codeLength': state.codeLength,
        // The server may answer with an existing challenge (`resumed`) when this
        // number was already sent a code — the screen then settles that one.
        'challengeId': state.challengeId,
      },
    );
    // The OTP screen popped: accept a new "send" from this screen again.
    if (mounted) _isOpeningOtp = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isVendor = widget.role == 'vendor';
    final roleColor = isVendor ? AppColors.primary : AppColors.customerAccent;
    final roleLabel = isVendor ? l10n.vendor : l10n.customer;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          // Only the originator may navigate, and only while it is on screen.
          // The OTP screen sends its own `resend` requests through this same
          // bloc; reacting to those here is what used to stack OTP screens.
          if (state.origin == OtpSendOrigin.phoneEntry) _openOtpScreen(state);
        } else if (state is AuthError) {
          if (!mounted || !_isCurrentRoute) return;
          AppToast.show(context, state.message, type: ToastType.error);
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
                    l10n.logIn,
                    style: AppTypography.h1.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.enterPhoneNumberToContinue,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 24,
                          color: isDark ? Colors.white24 : AppColors.divider,
                        ),
                        const SizedBox(width: 10),
                        const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '+91',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 24,
                          color: isDark ? Colors.white24 : AppColors.divider,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: AppTypography.bodyMedium.copyWith(
                              color: cs.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.phonePlaceholder,
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textHint,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: l10n.sendOtp,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: '${l10n.havingTrouble} ',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.useEmailInstead,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push(
                                AppRouter.emailLogin,
                                extra: widget.role,
                              ),
                          ),
                        ],
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
