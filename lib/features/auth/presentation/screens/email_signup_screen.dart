import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/location_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/location_picker_tile.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class EmailSignupScreen extends StatefulWidget {
  final String role;
  const EmailSignupScreen({super.key, required this.role});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  static const List<String> _kVendorCategories = [
    'Milk / Dairy',
    'Press / Dhobi',
    'Maid / Cook',
    'Newspaper',
    'Water Can',
    'Tiffin / Food',
    'Kirana / Grocery',
    'Salon / Parlour',
    'Construction Labour',
    'Transport / Auto',
    'Gym / Fitness',
    'Other',
  ];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _upiController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  final List<String> _selectedCategories = [];
  LocationData? _pickedLocation;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx)!;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      AppToast.show(ctx, l10n.fillRequiredFields, type: ToastType.warning);
      return;
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      AppToast.show(ctx, l10n.invalidEmailAddress, type: ToastType.error);
      return;
    }
    if (password != confirm) {
      AppToast.show(ctx, AppLocalizations.of(ctx)!.passwordsDoNotMatch,
          type: ToastType.error);
      return;
    }
    if (password.length < 8) {
      AppToast.show(ctx, AppLocalizations.of(ctx)!.passwordTooShort,
          type: ToastType.error);
      return;
    }

    ctx.read<AuthBloc>().add(
          AuthEmailSignupRequested(
            email: email,
            password: password,
            name: name,
            role: widget.role,
            upiId: _upiController.text.trim().isEmpty ? null : _upiController.text.trim(),
            businessName: _businessNameController.text.trim().isEmpty
                ? null
                : _businessNameController.text.trim(),
            businessCategory: _selectedCategories.isNotEmpty ? _selectedCategories.first : null,
            businessCategories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
            businessAddress: _businessAddressController.text.trim().isEmpty
                ? null
                : _businessAddressController.text.trim(),
            customerLatitude: widget.role == 'customer' ? _pickedLocation?.lat : null,
            customerLongitude: widget.role == 'customer' ? _pickedLocation?.lng : null,
            customerAddress: widget.role == 'customer' ? _pickedLocation?.displayName : null,
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
      listener: (ctx, state) {
        if (state is AuthError) {
          AppToast.show(ctx, state.message, type: ToastType.error);
        }
      },
      builder: (ctx, state) {
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
                    child: Icon(Icons.arrow_back, size: 24, color: cs.onSurface),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                    AppLocalizations.of(context)!.createAccountButton,
                    style: AppTypography.h1.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.signUpEmailSubtitle,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),

                  // ─── Core fields ───────────────────────────────────────────
                  _InputField(
                    controller: _nameController,
                    hintText: l10n.fullName,
                    prefixIcon: Icons.person_outline_rounded,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: _emailController,
                    hintText: l10n.emailPlaceholder,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: _passwordController,
                    hintText:
                        l10n.passwordWithMinHint(l10n.password),
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    enabled: !isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InputField(
                    controller: _confirmController,
                    hintText: l10n.passwordOptionalHint,
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscureConfirm,
                    enabled: !isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),

                  // ─── Vendor-only fields ────────────────────────────────────
                  if (isVendor) ...[
                    const SizedBox(height: 20),
                    _InputField(
                      controller: _businessNameController,
                      hintText: l10n.businessName,
                      prefixIcon: Icons.store_rounded,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.businessCategory, style: AppTypography.labelLarge),
                        Text(
                          l10n.customCategoryCountLabel(
                      _selectedCategories.length),
                          style: AppTypography.bodySmall.copyWith(
                            color: _selectedCategories.length >= 3
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: _kVendorCategories.map((cat) {
                          final isSelected = _selectedCategories.contains(cat);
                          final isDisabled = !isSelected && _selectedCategories.length >= 3;
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: isLoading || isDisabled
                                ? null
                                : (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedCategories.add(cat);
                                      } else {
                                        _selectedCategories.remove(cat);
                                      }
                                    });
                                  },
                            title: Text(
                              cat,
                              style: TextStyle(color: isDisabled ? AppColors.textHint : null),
                            ),
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LocationPickerTile(
                      location: _pickedLocation,
                      enabled: !isLoading,
                      onTap: () async {
                        final result = await context.push<LocationData>(
                          AppRouter.locationPicker,
                          extra: _pickedLocation,
                        );
                        if (result != null) {
                          setState(() {
                            _pickedLocation = result;
                            _businessAddressController.text = result.displayName;
                          });
                        }
                      },
                    ),
                  ],

                  // ─── Customer-only fields ──────────────────────────────────
                  if (!isVendor) ...[
                    const SizedBox(height: 20),
                    LocationPickerTile(
                      location: _pickedLocation,
                      enabled: !isLoading,
                      onTap: () async {
                        final result = await context.push<LocationData>(
                          AppRouter.locationPicker,
                          extra: _pickedLocation,
                        );
                        if (result != null) setState(() => _pickedLocation = result);
                      },
                    ),
                  ],

                  // ─── UPI (optional) ────────────────────────────────────────
                  const SizedBox(height: 20),
                  _InputField(
                    controller: _upiController,
                    hintText: l10n.upiIdOptionalLabel,
                    prefixIcon: Icons.payments_rounded,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    label: l10n.createAccountButton,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(ctx),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: isLoading
                          ? null
                          : () => context.pushReplacement(
                                AppRouter.emailLogin,
                                extra: widget.role,
                              ),
                      child: RichText(
                        text: TextSpan(
                          text: '${l10n.alreadyHaveAccount} ',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: l10n.logIn,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.primary,
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(prefixIcon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Container(width: 1, height: 24, color: isDark ? Colors.white24 : AppColors.divider),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              enabled: enabled,
              style: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          ?suffixIcon,
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
