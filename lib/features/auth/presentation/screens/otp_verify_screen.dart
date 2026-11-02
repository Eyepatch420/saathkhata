import 'dart:async';

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

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  final String role;

  /// Server-provided cool-down. The countdown is cosmetic: the backend rejects
  /// an early resend regardless of the device clock.
  final int resendAfterSeconds;

  /// Digits the provider issued (UDO = 5), straight from `POST /auth/otp/send`.
  final int codeLength;

  /// The challenge this screen settles. Every verify echoes it back, and a resend
  /// replaces it, so two devices (or a re-entered number) can never mix codes.
  final String? challengeId;

  const OtpVerifyScreen({
    super.key,
    required this.phone,
    required this.role,
    this.resendAfterSeconds = 60,
    this.codeLength = 5,
    this.challengeId,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  /// ONE controller holds the whole code. A single (invisible) text field laid
  /// over the boxes is what makes system SMS autofill, keyboard paste and the
  /// long-press paste menu work: Android hands the entire code to one input,
  /// which the formatter trims to `codeLength` digits. Five separate fields can
  /// never receive a multi-digit paste or an autofill event.
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _resendTimer;
  int _secondsUntilResend = 0;

  /// Normalised once, so this screen, the verify call and the resend all use the
  /// same canonical 10 digits — never `+91`, spaces or a trunk zero.
  late String _phone;

  /// Kept in state (not read from the widget) because a resend may be answered
  /// with a different provider-side length.
  late int _codeLength;

  /// Current challenge id. Starts from the route (`/otp/send` created it) and is
  /// replaced whenever a resend issues a new one — never left stale, otherwise the
  /// next verify would be answered with "this challenge is gone".
  String? _challengeId;

  /// Blocks a double tap on the resend link while its request is in flight.
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _phone = normalizeIndianPhone(widget.phone);
    _codeLength = widget.codeLength > 0 ? widget.codeLength : 5;
    _challengeId = widget.challengeId;
    _startResendCountdown(widget.resendAfterSeconds, notify: false);
    // Rebuild the boxes whenever the code — or the focus — changes.
    _controller.addListener(_onCodeChanged);
    _focusNode.addListener(_onFocusChanged);
    // Open the keyboard immediately; autofill and paste need a focused input.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showKeyboard());
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onCodeChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  /// Brings the keyboard back up — including the case where Android's back
  /// button dismissed it while the field kept focus.
  ///
  /// A plain `requestFocus()` is a no-op when the node already holds focus, and
  /// that is exactly the state a dismissed keyboard leaves behind: tapping the
  /// boxes then silently did nothing. Dropping focus first forces the text-input
  /// connection to be re-attached, after which the keyboard shows again.
  Future<void> _showKeyboard() async {
    if (!mounted) return;
    // `viewInsets.bottom` is the on-screen keyboard height: zero means it is
    // hidden, which is the only case that needs the re-attach dance. Tapping
    // while the keyboard is already up must not make it flicker.
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (_focusNode.hasFocus && keyboardVisible) return;
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      // EditableText tears its input connection down on the following frame.
      await Future<void>.delayed(const Duration(milliseconds: 40));
      if (!mounted) return;
    }
    _focusNode.requestFocus();
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
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

  String get _otp => _controller.text;

  /// True when this screen is the visible route: a screen buried underneath
  /// must never show toasts or react to events that belong to the one on top.
  bool get _isCurrentRoute => ModalRoute.of(context)?.isCurrent ?? false;

  void _submit(BuildContext context) {
    final otp = _otp;
    final l10n = AppLocalizations.of(context)!;
    if (otp.length != _codeLength) {
      AppToast.show(
        context,
        l10n.enterAllDigits(_codeLength),
        type: ToastType.warning,
      );
      _showKeyboard();
      return;
    }
    context.read<AuthBloc>().add(
      AuthOtpVerifyRequested(
        phone: _phone,
        otp: otp,
        role: widget.role,
        challengeId: _challengeId,
      ),
    );
  }

  void _resend(BuildContext context) {
    if (_secondsUntilResend > 0 || _isResending) return;
    _isResending = true;
    // Deliberately do NOT clear the boxes here: if the server rejects the
    // resend (cool-down, hourly cap, provider outage) a half-typed code must
    // survive. The boxes are cleared only once a new code was really issued.
    context.read<AuthBloc>().add(
      AuthOtpSendRequested(phone: _phone, origin: OtpSendOrigin.resend),
    );
  }

  /// Clears every box (used when the challenge is no longer usable).
  void _clearDigits() {
    _controller.clear();
    _showKeyboard();
  }

  /// Applies a confirmed resend: new cool-down, clean boxes, keyboard ready.
  void _onResent(AuthOtpSent state) {
    if (!mounted) return;
    setState(() {
      _isResending = false;
      _phone = normalizeIndianPhone(state.phone);
      if (state.codeLength > 0) _codeLength = state.codeLength;
      // A resend either issued a new challenge or resumed the live one; either way
      // this is now the challenge this screen settles.
      if (state.challengeId != null) _challengeId = state.challengeId;
    });
    _controller.clear();
    _startResendCountdown(state.resendAfterSeconds);
    _showKeyboard();
  }

  /// Shows the failure and reacts to the *code*, not to the prose.
  void _handleError(AuthError state) {
    if (!mounted) return;
    final code = state.code;
    _isResending = false;
    AppToast.show(context, state.message, type: ToastType.error);

    // Only failures that invalidate the submitted code clear the boxes. A
    // network timeout or a provider outage (`code == null`) must never throw
    // away what the user already typed.
    const unusable = {
      'OTP_INVALID',
      'OTP_EXPIRED',
      'OTP_LOCKED',
      'OTP_ALREADY_USED',
      'OTP_NOT_READY',
      'OTP_VERIFY_IN_PROGRESS',
    };
    if (code != null && unusable.contains(code)) {
      _clearDigits();
    } else {
      _showKeyboard();
    }

    if (code == 'OTP_COOLDOWN' ||
        code == 'OTP_RATE_LIMITED' ||
        code == 'OTP_LOCKED' ||
        // The code was redeemed (possibly on another device). The server sends the
        // remaining cool-down, so the resend link unlocks at the right moment instead
        // of leaving the user guessing.
        code == 'OTP_ALREADY_USED') {
      // Trust the server's window (it measures real elapsed time); fall back to
      // this screen's cool-down, never to a shorter hard-coded value.
      _startResendCountdown(
        state.retryAfterSeconds ?? widget.resendAfterSeconds,
      );
    }
  }

  /// Leaves this screen without ever emptying the navigator.
  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    // Deep-linked straight to /otp-verify: there is no number screen below.
    context.pushReplacement(AppRouter.phoneEntry, extra: widget.role);
  }

  /// One visual box. Typing/pasting/autofill all happen in the single hidden
  /// field below, so the boxes are display-only.
  Widget _buildDigitBox(BuildContext context, int index) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final code = _controller.text;
    final digit = index < code.length ? code[index] : '';
    final isActive = _focusNode.hasFocus && index == code.length;
    // Five digits keep the design width; a longer provider-issued code shrinks
    // the boxes so the row still fits on a narrow phone.
    final boxWidth = _codeLength <= 5 ? 52.0 : 260.0 / _codeLength;

    return Container(
      width: boxWidth,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.45),
          width: isActive ? 2 : 1.5,
        ),
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
      child: Text(
        digit,
        style: AppTypography.h2.copyWith(color: cs.onSurface),
      ),
    );
  }

  /// The single input that receives every digit.
  ///
  /// - `AutofillHints.oneTimeCode` lets Android offer the code from the SMS
  ///   (system autofill / SMS Retriever consent sheet).
  /// - It stays a normal, selectable text field, so the long-press menu and the
  ///   keyboard's clipboard both paste the whole code into it; the formatter
  ///   keeps the first `codeLength` digits and the boxes re-render.
  Widget _buildCodeInput() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      // Focus is opened deliberately after the first frame (see _showKeyboard);
      // `autofocus` would race with it and leave the field focused with no
      // visible keyboard on some Android OEMs.
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.oneTimeCode],
      enableInteractiveSelection: true,
      maxLength: _codeLength,
      showCursor: false,
      cursorColor: Colors.transparent,
      style: const TextStyle(color: Colors.transparent, fontSize: 1),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(_codeLength),
      ],
      decoration: const InputDecoration(
        counterText: '',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      onSubmitted: (_) => _submit(context),
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
        if (!mounted) return;
        if (state is AuthOtpVerifiedNewUser) {
          if (!_isCurrentRoute) return;
          context.push(
            AppRouter.profileSetup,
            extra: {'signupToken': state.signupToken, 'phone': state.phone},
          );
        } else if (state is AuthOtpSent) {
          // Only this screen's own resend belongs here. The number screen's
          // first send is not this screen's business — reacting to every
          // `AuthOtpSent` is what used to stack OTP screens on each resend.
          if (state.origin == OtpSendOrigin.resend) _onResent(state);
        } else if (state is AuthError) {
          if (_isCurrentRoute) _handleError(state);
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
                    onTap: () => _goBack(context),
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
                          text: formatIndianPhone(_phone),
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
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          _codeLength,
                          (i) => _buildDigitBox(context, i),
                        ),
                      ),
                      // Invisible, full-width input that owns the keyboard,
                      // the SMS autofill and the paste menu.
                      Positioned.fill(
                        child: Opacity(opacity: 0, child: _buildCodeInput()),
                      ),
                      // Tapping anywhere on the boxes (re)opens the keyboard,
                      // even when a system back-press hid it while the field
                      // kept focus.
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _showKeyboard,
                        ),
                      ),
                    ],
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
                      onTap: (isLoading || _secondsUntilResend > 0 || _isResending)
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
