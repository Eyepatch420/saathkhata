import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../shared/models/location_model.dart';
import '../../../../shared/widgets/location_picker_tile.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ProfileSetupScreen extends StatefulWidget {
  /// When arriving from OTP flow: extra = { 'signupToken': ..., 'phone': ... }
  /// role is chosen on this screen (vendor / customer selector).
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  List<String> _vendorCategories(AppLocalizations l10n) => [
    l10n.businessCategoryMilkDairy,
    l10n.businessCategoryPressDhobi,
    l10n.businessCategoryMaidCook,
    l10n.businessCategoryNewspaper,
    l10n.businessCategoryWaterCan,
    l10n.businessCategoryTiffinFood,
    l10n.businessCategoryKiranaGrocery,
    l10n.businessCategorySalonParlour,
    l10n.businessCategoryConstructionLabour,
    l10n.businessCategoryTransportAuto,
    'Gym / Fitness',
    l10n.businessCategoryOther,
  ];

  final _picker = ImagePicker();

  // Extracted from route extra
  late String _signupToken;
  late String _phone;

  // Role selection (replaces the old RoleSelectionScreen step here)
  String _role = 'vendor';

  // Form state
  final List<String> _selectedCategories = [];
  XFile? _pickedImage;
  bool _isUploadingPhoto = false;
  LocationData? _pickedLocation;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _upiController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra =
        GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};
    _signupToken = extra['signupToken'] as String? ?? '';
    _phone = extra['phone'] as String? ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  // ─── Photo picker ──────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final xFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (xFile != null) setState(() => _pickedImage = xFile);
    } catch (_) {}
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primary,
              ),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: AppColors.primary,
              ),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_pickedImage != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_rounded,
                  color: AppColors.error,
                ),
                title: Text(
                  AppLocalizations.of(context)!.removePhoto,
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  setState(() => _pickedImage = null);
                  Navigator.pop(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Photo upload (after signup) ──────────────────────────────────────────

  Future<void> _uploadPhotoThenNavigate(AuthAuthenticated state) async {
    final destination = state.user.isVendor
        ? AppRouter.vendorHome
        : AppRouter.customerHome;
    if (_pickedImage == null) {
      if (mounted) context.go(destination);
      return;
    }
    setState(() => _isUploadingPhoto = true);
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          _pickedImage!.path,
          filename: 'profile.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });
      await getIt<ApiClient>().postFormData(
        ApiEndpoints.uploadPhoto,
        formData: formData,
      );
    } catch (_) {
      // Non-critical — user can set photo from profile later
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
        context.go(destination);
      }
    }
  }

  // ─── Submit ────────────────────────────────────────────────────────────────

  void _handleSignup(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.show(ctx, l10n.nameRequired, type: ToastType.warning);
      return;
    }
    if (_signupToken.isEmpty) {
      AppToast.show(
        ctx,
        l10n.sessionExpiredVerifyPhoneAgain,
        type: ToastType.error,
      );
      context.go(AppRouter.phoneEntry);
      return;
    }

    ctx.read<AuthBloc>().add(
      AuthSignupRequested(
        signupToken: _signupToken,
        name: name,
        role: _role,
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        upiId: _upiController.text.trim().isEmpty
            ? null
            : _upiController.text.trim(),
        businessName: _businessNameController.text.trim().isEmpty
            ? null
            : _businessNameController.text.trim(),
        businessCategory: _selectedCategories.isNotEmpty ? _selectedCategories.first : null,
        businessCategories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
        businessAddress: _businessAddressController.text.trim().isEmpty
            ? null
            : _businessAddressController.text.trim(),
        customerLatitude: _role == 'customer' ? _pickedLocation?.lat : null,
        customerLongitude: _role == 'customer' ? _pickedLocation?.lng : null,
        customerAddress: _role == 'customer' ? _pickedLocation?.displayName : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = _role == 'vendor';

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthAuthenticated) {
          _uploadPhotoThenNavigate(state);
        } else if (state is AuthError) {
          AppToast.show(ctx, state.message, type: ToastType.error);
        }
      },
      builder: (ctx, state) {
        final l10n = AppLocalizations.of(ctx)!;
        final isLoading = state is AuthLoading || _isUploadingPhoto;
        final loadingLabel = _isUploadingPhoto
            ? l10n.uploadingPhotoLabel
            : l10n.createAccountButton;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.completeProfile)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Profile photo ─────────────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: isLoading ? null : _showPhotoOptions,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            backgroundImage: _pickedImage != null
                                ? FileImage(File(_pickedImage!.path))
                                : null,
                            child: _pickedImage == null
                                ? const Icon(
                                    Icons.person_outline,
                                    size: 50,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      l10n.tapToAddProfilePhoto,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── Phone (pre-filled, locked) ────────────────────────
                  if (_phone.isNotEmpty) ...[
                    Text(
                      l10n.phoneNumberLabel,
                      style: AppTypography.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_android_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text('+91 $_phone', style: AppTypography.bodyMedium),
                          const Spacer(),
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.textHint,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ─── Role toggle ───────────────────────────────────────
                  Text(l10n.iAmA, style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = 'vendor'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _role == 'vendor'
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _role == 'vendor'
                                    ? AppColors.primary
                                    : AppColors.divider,
                                width: _role == 'vendor' ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storefront_rounded,
                                  color: _role == 'vendor'
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.vendor,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _role == 'vendor'
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                    fontWeight: _role == 'vendor'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _role = 'customer'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _role == 'customer'
                                  ? AppColors.customerAccent.withValues(
                                      alpha: 0.12,
                                    )
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _role == 'customer'
                                    ? AppColors.customerAccent
                                    : AppColors.divider,
                                width: _role == 'customer' ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search_rounded,
                                  color: _role == 'customer'
                                      ? AppColors.customerAccent
                                      : AppColors.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.customer,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _role == 'customer'
                                        ? AppColors.customerAccent
                                        : AppColors.textSecondary,
                                    fontWeight: _role == 'customer'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ─── Name ──────────────────────────────────────────────
                  CustomTextField(
                    label: l10n.fullName,
                    hintText: l10n.enterYourName,
                    prefixIcon: Icons.person_rounded,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),

                  // ─── Email (optional) ──────────────────────────────────
                  CustomTextField(
                    label: l10n.emailOptionalLabel,
                    hintText: l10n.emailPlaceholder,
                    prefixIcon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),

                  // ─── Vendor-only fields ────────────────────────────────
                  if (isVendor) ...[
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: l10n.businessName,
                      hintText: l10n.egBusinessName,
                      prefixIcon: Icons.store_rounded,
                      controller: _businessNameController,
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
                        children: _vendorCategories(l10n).map((cat) {
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
                              style: TextStyle(
                                color: isDisabled ? AppColors.textHint : null,
                              ),
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
                            _businessAddressController.text =
                                result.displayName;
                          });
                        }
                      },
                    ),
                  ],

                  // ─── Customer-only: location picker ───────────────────
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
                        if (result != null) {
                          setState(() => _pickedLocation = result);
                        }
                      },
                    ),
                  ],

                  // ─── UPI (optional) ────────────────────────────────────
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: l10n.upiIdOptionalLabel,
                    hintText: l10n.upiHint,
                    prefixIcon: Icons.payments_rounded,
                    controller: _upiController,
                  ),
                  const SizedBox(height: 40),

                  PrimaryButton(
                    label: loadingLabel,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _handleSignup(ctx),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : () => ctx.pop(),
                      child: RichText(
                        text: TextSpan(
                          text: '${l10n.alreadyHaveAccount} ',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.goBackButton,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
