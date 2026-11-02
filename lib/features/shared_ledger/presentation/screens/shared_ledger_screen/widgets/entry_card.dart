import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/ledger_entry.dart';
import '../../../../../../shared/widgets/app_toast.dart';
import '../../../../../../features/shared_ledger/domain/utils/ledger_permissions.dart';
import '../../../bloc/ledger_bloc.dart';
import '../../../bloc/ledger_event.dart';
import '../../../../../../features/shared_ledger/domain/repositories/ledger_repository.dart';
import 'attachment_section.dart';
import 'detail_row.dart';
import 'status_chip.dart';

class LedgerEntryCard extends StatefulWidget {
  final LedgerEntry entry;
  final String customerName;
  final String currentUserId;
  final bool isVendorView;
  final bool isStaffView;

  const LedgerEntryCard({
    super.key,
    required this.entry,
    required this.customerName,
    required this.currentUserId,
    required this.isVendorView,
    this.isStaffView = false,
  });

  @override
  State<LedgerEntryCard> createState() => _LedgerEntryCardState();
}

class _LedgerEntryCardState extends State<LedgerEntryCard> {
  bool _expanded = false;

  LedgerEntry get entry => widget.entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCredit = entry.type == EntryType.credit;

    return GestureDetector(
      onTap: entry.isParent
          ? () => setState(() => _expanded = !_expanded)
          : () => _showEntryDetail(context, l10n),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: entry.status == EntryStatus.disputed
              ? Border.all(color: AppColors.error.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isCredit ? AppColors.error : AppColors.success)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCredit
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: isCredit ? AppColors.error : AppColors.success,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.description ??
                                  (isCredit
                                      ? l10n.entryTypeCreditLabel
                                      : l10n.entryTypePaymentLabel),
                              style: AppTypography.labelLarge,
                            ),
                          ),
                          if (entry.isParent) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textHint.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .itemsCountShort(entry.childCount),
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(entry.date),
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${entry.amount.toStringAsFixed(0)}',
                      style: AppTypography.h3.copyWith(
                        color: isCredit ? AppColors.error : AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (entry.isParent)
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.textHint,
                      )
                    else
                      LedgerStatusChip(status: entry.status),
                  ],
                ),
              ],
            ),
            // Expanded children section for parent entries
            if (entry.isParent && _expanded && entry.children.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...entry.children.map((child) => _ChildEntryRow(child: child)),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalLabel,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '₹${entry.amount.toStringAsFixed(2)}',
                    style: AppTypography.labelLarge.copyWith(
                      color: isCredit ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  entry.isDelivery
                      ? _DeliveryChip(entry: entry)
                      : LedgerStatusChip(status: entry.status),
                ],
              ),
              // Delivery proof photo (if the deliverer attached one).
              if (entry.isDelivery && entry.attachmentUrl != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.photo_camera_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.deliveryProofLabel,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LedgerAttachmentSection(
                  attachmentUrl: entry.attachmentUrl,
                  isLocked: entry.isLocked,
                  heroTag: 'delivery_proof_${entry.id}',
                ),
              ],
            ],
            // Confirm/dispute is shown to whichever party did NOT create
            // the entry — never to the creator and never to staff.
            //
            // createdBy == customerId  →  customer created it  →  vendor confirms
            // createdBy != customerId  →  vendor/staff created →  customer confirms
            if (!widget.isStaffView &&
                entry.isPendingConfirmation &&
                _shouldShowConfirmDispute(entry, widget.isVendorView)) ...[
              const Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showDisputeSheet(context, l10n),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minimumSize: const Size(0, 36),
                      ),
                      child: Text(
                        l10n.dispute,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmEntry(context, l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minimumSize: const Size(0, 36),
                      ),
                      child: Text(
                        l10n.confirm,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (entry.status == EntryStatus.disputed &&
                entry.disputeReason != null) ...[
              const Divider(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entry.disputeReason!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Returns true for the party that did NOT create the entry.
  // Customer created → vendor confirms. Vendor/staff created → customer confirms.
  bool _shouldShowConfirmDispute(LedgerEntry entry, bool isVendorView) {
    final customerCreated = entry.createdBy == entry.customerId;
    return customerCreated ? isVendorView : !isVendorView;
  }

  void _confirmEntry(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.confirmEntryTitle),
        content: Text(
          l10n.confirmEntryMessage(entry.amount.toStringAsFixed(0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<LedgerBloc>().add(ConfirmLedgerEntry(entry.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisputeSheet(BuildContext context, AppLocalizations l10n) {
    final bloc = context.read<LedgerBloc>();
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            // viewInsets clears the keyboard; viewPadding clears the gesture
            // bar / 3-button nav when the keyboard is closed.
            bottom: mq.viewInsets.bottom + mq.viewPadding.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.raiseDisputeTitle, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  l10n.raiseDisputeSubtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.raiseDisputeHint,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        Navigator.pop(ctx);
                        bloc.add(
                          DisputeLedgerEntry(
                            entryId: entry.id,
                            reason: controller.text.trim(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      l10n.submitDispute,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEntryDetail(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EntryDetailSheet(
        entry: entry,
        currentUserId: widget.currentUserId,
        isVendorView: widget.isVendorView,
        isStaffView: widget.isStaffView,
        l10n: l10n,
      ),
    );
  }
}

class _ChildEntryRow extends StatelessWidget {
  final LedgerEntry child;
  const _ChildEntryRow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 4),
          const Icon(
            Icons.subdirectory_arrow_right_rounded,
            size: 14,
            color: AppColors.textHint,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              child.description ??
                  AppLocalizations.of(context)!.item,
              style: AppTypography.bodyMedium,
            ),
          ),
          if (child.quantity != null)
            Text(
              '${child.quantity!.toStringAsFixed(child.quantity! % 1 == 0 ? 0 : 2)} ${child.unit ?? ''}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          const SizedBox(width: 12),
          Text(
            '₹${child.amount.toStringAsFixed(2)}',
            style: AppTypography.labelLarge,
          ),
        ],
      ),
    );
  }
}

/// Friendly chip for auto-created delivery entries: "Delivered by vendor/staff"
/// instead of the raw "Auto-Confirmed" status.
class _DeliveryChip extends StatelessWidget {
  final LedgerEntry entry;
  const _DeliveryChip({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_shipping_rounded,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 4),
          Text(
            entry.deliveredByRole != null
                ? AppLocalizations.of(context)!
                    .deliveredByRoleLabel(entry.deliveredByRole!)
                : AppLocalizations.of(context)!.deliveredOnlyLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryDetailSheet extends StatefulWidget {
  final LedgerEntry entry;
  final String currentUserId;
  final bool isVendorView;
  final bool isStaffView;
  final AppLocalizations l10n;

  const _EntryDetailSheet({
    required this.entry,
    required this.currentUserId,
    required this.isVendorView,
    required this.isStaffView,
    required this.l10n,
  });

  @override
  State<_EntryDetailSheet> createState() => _EntryDetailSheetState();
}

class _EntryDetailSheetState extends State<_EntryDetailSheet> {
  bool _uploadInProgress = false;

  Future<void> _attachProof() async {
    final source = await _showSourcePicker();
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploadInProgress = true);
    try {
      await getIt<LedgerRepository>().attachToEntry(
        widget.entry.id,
        widget.entry.linkId,
        File(picked.path),
      );
      if (mounted) {
        Navigator.pop(context);
        AppToast.show(
          context,
          AppLocalizations.of(context)!.proofAttachedToast,
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadInProgress = false);
        AppToast.show(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          type: ToastType.error,
        );
      }
    }
  }

  Future<ImageSource?> _showSourcePicker() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(AppLocalizations.of(ctx)!.camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(AppLocalizations.of(ctx)!.gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final entry = widget.entry;
    final canEdit = canEditAttachment(
      entry: entry,
      currentUserId: widget.currentUserId,
      isVendorView: widget.isVendorView,
    );

    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        mq.viewInsets.bottom + mq.viewPadding.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.entryDetails, style: AppTypography.h3),
                entry.isDelivery
                    ? _DeliveryChip(entry: entry)
                    : LedgerStatusChip(status: entry.status),
              ],
            ),
            const SizedBox(height: 20),
            LedgerDetailRow(
              l10n.entryAmount,
              '₹${entry.amount.toStringAsFixed(2)}',
            ),
            LedgerDetailRow(
              l10n.entryType,
              entry.type == EntryType.credit
                  ? l10n.entryTypeCreditGiven
                  : l10n.entryTypePaymentReceived,
            ),
            LedgerDetailRow(
              l10n.entryDate,
              DateFormat('dd MMM yyyy, hh:mm a').format(entry.date),
            ),
            if (entry.description != null)
              LedgerDetailRow(l10n.entryDescription, entry.description!),
            if (entry.quantity != null)
              LedgerDetailRow(
                l10n.entryQuantity,
                '${entry.quantity} ${entry.unit ?? ''}',
              ),
            if (entry.confirmedAt != null)
              LedgerDetailRow(
                l10n.entryConfirmedAt,
                DateFormat('dd MMM yyyy').format(entry.confirmedAt!),
              ),
            if (entry.disputeReason != null)
              LedgerDetailRow(l10n.entryDisputeReason, entry.disputeReason!),
            if (entry.attachmentUrl != null) ...[
              const Divider(height: 24),
              LedgerAttachmentSection(
                attachmentUrl: entry.attachmentUrl,
                isLocked: entry.isLocked,
                heroTag: 'detail_attachment_${entry.id}',
              ),
              const SizedBox(height: 8),
              if (entry.isLocked)
                Row(
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      size: 12,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.proofLockedHint,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              if (canEdit) ...[
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: _uploadInProgress ? null : _attachProof,
                  icon: _uploadInProgress
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 14),
                  label: Text(
                    AppLocalizations.of(context)!.replacePhotoButton,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
            if (entry.attachmentUrl == null && canEdit) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _uploadInProgress ? null : _attachProof,
                  icon: _uploadInProgress
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.attach_file_rounded, size: 16),
                  label: Text(
                    _uploadInProgress
                        ? AppLocalizations.of(context)!.uploadingLabel
                        : AppLocalizations.of(context)!.attachProofButton,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
