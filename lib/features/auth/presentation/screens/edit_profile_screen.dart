import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/models/location_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/location_picker_tile.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // Matches VENDOR_CATEGORIES in backend constants/index.ts
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

  late final TextEditingController _nameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _upiCtrl; // customers only
  late final TextEditingController _bizNameCtrl;

  // Vendor category multi-select
  List<String> _selectedCategories = [];

  // Location state — vendor business address or customer delivery address
  LocationData? _pickedLocation;

  File? _pickedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _mobileCtrl = TextEditingController(text: widget.user.mobile ?? '');
    _upiCtrl = TextEditingController(text: widget.user.upiId ?? '');
    _bizNameCtrl = TextEditingController(text: widget.user.businessName ?? '');

    // Pre-populate location if the user already has coordinates saved
    if (widget.user.isVendor &&
        widget.user.businessLatitude != null &&
        widget.user.businessLongitude != null) {
      _pickedLocation = LocationData(
        lat: widget.user.businessLatitude!,
        lng: widget.user.businessLongitude!,
        displayName: widget.user.businessAddress ?? '',
      );
    } else if (!widget.user.isVendor &&
        widget.user.customerLatitude != null &&
        widget.user.customerLongitude != null) {
      _pickedLocation = LocationData(
        lat: widget.user.customerLatitude!,
        lng: widget.user.customerLongitude!,
        displayName: widget.user.customerAddress ?? '',
      );
    }

    // Pre-populate categories from stored profile
    if (widget.user.isVendor) {
      _selectedCategories = List<String>.from(
        widget.user.businessCategories.isNotEmpty
            ? widget.user.businessCategories
            : (widget.user.businessCategory != null
                ? [widget.user.businessCategory!]
                : []),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _upiCtrl.dispose();
    _bizNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null && mounted) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(AppLocalizations.of(ctx)!.camera),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(AppLocalizations.of(ctx)!.gallery),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_pickedImage != null || widget.user.profilePhotoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error),
                title: Text(AppLocalizations.of(ctx)!.removePhoto,
                    style: const TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _pickedImage = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    bool photoUploadFailed = false;

    try {
      // ── Step 1: upload photo if one was picked ──────────────────────────────
      if (_pickedImage != null) {
        try {
          final formData = FormData.fromMap({
            'photo': await MultipartFile.fromFile(
              _pickedImage!.path,
              filename: 'profile.jpg',
            ),
          });
          await getIt<ApiClient>()
              .postFormData(ApiEndpoints.uploadPhoto, formData: formData);
        } catch (_) {
          photoUploadFailed = true;
        }
      }

      if (!mounted) return;

      // ── Step 2: update profile fields ──────────────────────────────────────
      final updated = await getIt<AuthRepository>().updateProfile(
        name: _nameCtrl.text.trim(),
        mobile: _mobileCtrl.text.trim().isEmpty
            ? null
            : _mobileCtrl.text.trim(),
        // Customer UPI only — vendors manage UPI IDs via UpiManagementScreen
        upiId: !widget.user.isVendor && _upiCtrl.text.trim().isNotEmpty
            ? _upiCtrl.text.trim()
            : null,
        businessName:
            widget.user.isVendor && _bizNameCtrl.text.trim().isNotEmpty
                ? _bizNameCtrl.text.trim()
                : null,
        businessCategory: widget.user.isVendor && _selectedCategories.isNotEmpty
            ? _selectedCategories.first
            : null,
        businessCategories: widget.user.isVendor && _selectedCategories.isNotEmpty
            ? _selectedCategories
            : null,
        businessAddress: widget.user.isVendor
            ? (_pickedLocation?.displayName ?? widget.user.businessAddress)
            : null,
        businessLatitude:
            widget.user.isVendor ? _pickedLocation?.lat : null,
        businessLongitude:
            widget.user.isVendor ? _pickedLocation?.lng : null,
        customerAddress: !widget.user.isVendor
            ? (_pickedLocation?.displayName ?? widget.user.customerAddress)
            : null,
        customerLatitude:
            !widget.user.isVendor ? _pickedLocation?.lat : null,
        customerLongitude:
            !widget.user.isVendor ? _pickedLocation?.lng : null,
      );

      if (!mounted) return;

      context.read<AuthBloc>().add(AuthUserUpdated(updated));

      if (photoUploadFailed) {
        AppToast.show(
          context,
          AppLocalizations.of(context)!.profileSavedPhotoFailed,
          type: ToastType.warning,
        );
      } else {
        AppToast.show(context,
            AppLocalizations.of(context)!.profileUpdatedSuccess,
            type: ToastType.success);
      }
      context.pop();
    } on Exception catch (e) {
      if (!mounted) return;
      AppToast.show(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _isSaving
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _save,
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ───────────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _showPhotoOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!) as ImageProvider
                              : widget.user.profilePhotoUrl != null
                                  ? NetworkImage(widget.user.profilePhotoUrl!)
                                  : null,
                          backgroundColor: AppColors.primary,
                          child: (_pickedImage == null &&
                                  widget.user.profilePhotoUrl == null)
                              ? const Icon(Icons.person_rounded,
                                  size: 50, color: Colors.white)
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
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Personal info ─────────────────────────────────────────────
                Text(
                  AppLocalizations.of(context)!.personalInfo,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullName,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context)!.nameRequired
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileCtrl,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.mobileNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                // ── Customer-only: UPI + delivery address ─────────────────────
                if (!widget.user.isVendor) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _upiCtrl,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.upiId,
                      hintText: AppLocalizations.of(context)!
                          .upiIdExampleHint,
                      prefixIcon: const Icon(
                          Icons.account_balance_wallet_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LocationPickerTile(
                    label:
                        AppLocalizations.of(context)!.deliveryAddressLabel,
                    location: _pickedLocation,
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

                // ── Vendor-only: business info ─────────────────────────────────
                if (widget.user.isVendor) ...[
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.businessInfo,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bizNameCtrl,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.businessName,
                      prefixIcon: const Icon(Icons.store_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category multi-select — min 1, max 3
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.businessCategory,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .customCategoryCountLabel(
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
                          children: [
                            ..._kVendorCategories.map((cat) {
                              final isSelected = _selectedCategories.contains(cat);
                              final isDisabled = !isSelected && _selectedCategories.length >= 3;
                              return CheckboxListTile(
                                value: isSelected,
                                onChanged: _isSaving || isDisabled
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
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .customCategoryOptionalLabel,
                          hintText: AppLocalizations.of(context)!
                              .ayurvedicMedicineExample,
                          helperText: AppLocalizations.of(context)!
                              .customCategoryHelper,
                          prefixIcon:
                              const Icon(Icons.add_circle_outline_rounded),
                        ),
                        enabled: !_isSaving && _selectedCategories.length < 3,
                        onFieldSubmitted: (val) {
                          final trimmed = val.trim();
                          if (trimmed.isNotEmpty &&
                              !_selectedCategories.contains(trimmed) &&
                              _selectedCategories.length < 3) {
                            setState(() => _selectedCategories.add(trimmed));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Location picker replaces the plain text address field
                  LocationPickerTile(
                    location: _pickedLocation,
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
