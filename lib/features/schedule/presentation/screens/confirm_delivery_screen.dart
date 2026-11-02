import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/ledger_attachment_service.dart';
import '../../../../shared/models/schedule_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../cubit/schedule_cubit.dart';

/// Confirms a scheduled delivery. Every field here is auto-filled and
/// read-only — the vendor/staff can't re-enter the amount, date, or names,
/// since the whole point is to avoid re-keying data that's already known.
/// A photo is mandatory before "Confirm Delivery" is enabled: it's uploaded
/// first (upload-first flow, same as the ledger's temp-attachment endpoint)
/// so its URL can be sent together with the confirm call, letting the
/// backend create the ledger entry already locked with proof attached
/// instead of allowing a photo-less confirm followed by a racy attach-after.
class ConfirmDeliveryScreen extends StatefulWidget {
  final ScheduledDelivery delivery;
  const ConfirmDeliveryScreen({super.key, required this.delivery});

  @override
  State<ConfirmDeliveryScreen> createState() => _ConfirmDeliveryScreenState();
}

class _ConfirmDeliveryScreenState extends State<ConfirmDeliveryScreen> {
  File? _photo;
  String? _uploadedUrl;
  bool _uploading = false;
  bool _confirming = false;

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _photo = File(picked.path);
      _uploadedUrl = null;
    });
  }

  Future<String?> _ensureUploaded() async {
    if (_uploadedUrl != null) return _uploadedUrl;
    if (_photo == null) return null;
    setState(() => _uploading = true);
    try {
      final url = await getIt<LedgerAttachmentService>().uploadAttachment(
        imageFile: _photo!,
        linkId: widget.delivery.linkId,
        entryId: null,
      );
      if (!mounted) return null;
      setState(() {
        _uploadedUrl = url;
        _uploading = false;
      });
      return url;
    } catch (e) {
      if (mounted) {
        setState(() => _uploading = false);
        AppToast.show(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          type: ToastType.error,
        );
      }
      return null;
    }
  }

  Future<void> _confirm() async {
    final url = await _ensureUploaded();
    if (url == null || !mounted) return;
    setState(() => _confirming = true);
    final ok = await context.read<DeliveriesCubit>().markDelivered(
      widget.delivery.id,
      photoUrl: url,
    );
    if (!mounted) return;
    setState(() => _confirming = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      AppToast.show(
        context,
        AppLocalizations.of(context)!.couldNotConfirmDelivery,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final delivery = widget.delivery;
    final authState = context.watch<AuthBloc>().state;
    final UserModel? me = authState is AuthAuthenticated
        ? authState.user
        : null;
    final staffName = me?.name ?? '—';
    final vendorName = me?.effectiveBusinessName ?? '—';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.confirmDeliveryButton)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(delivery.serviceName, style: AppTypography.h2),
            Text(
              l10n.forCustomerName(delivery.customerName),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            _ReadOnlyRow(
              icon: Icons.calendar_today_outlined,
              label: l10n.dateTimeLabel,
              value: DateFormat(
                'EEE, d MMM yyyy · h:mm a',
              ).format(DateTime.now()),
            ),
            _ReadOnlyRow(
              icon: Icons.person_outline,
              label: l10n.customer,
              value: delivery.customerName,
            ),
            _ReadOnlyRow(
              icon: Icons.badge_outlined,
              label: l10n.deliveredByLabel,
              value: staffName,
            ),
            _ReadOnlyRow(
              icon: Icons.storefront_outlined,
              label: l10n.vendor,
              value: vendorName,
            ),
            for (final item in delivery.items.where((i) => i.quantity > 0))
              _ReadOnlyRow(
                icon: Icons.inventory_2_outlined,
                label: item.name,
                value: '${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1)} ${item.unit}',
              ),
            if (delivery.totalAmount > 0)
              _ReadOnlyRow(
                icon: Icons.currency_rupee_rounded,
                label: l10n.amountToAddToLedger,
                value: '₹${delivery.totalAmount.toStringAsFixed(2)}',
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.deliveryAutoLedgerNote,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.deliveryPhotoRequired,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textHint,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            if (_photo == null) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickPhoto(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_rounded, size: 16),
                      label: Text(l10n.camera),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickPhoto(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded, size: 16),
                      label: Text(l10n.gallery),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _photo!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!_confirming)
                    Positioned(
                      top: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _photo = null;
                          _uploadedUrl = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_photo != null && !_uploading && !_confirming)
                    ? _confirm
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: (_uploading || _confirming)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.confirmDeliveryButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ReadOnlyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
