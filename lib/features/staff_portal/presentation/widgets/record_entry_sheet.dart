import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/ledger_attachment_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/models/link_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../shared_ledger/domain/repositories/ledger_repository.dart';
import '../../../shared_ledger/presentation/screens/shared_ledger_screen/widgets/attachment_section.dart';

/// Bottom sheet used by staff to record a delivery (credit) or collect a
/// payment. For deliveries it captures item / qty / unit-price and computes the
/// total; for payments it captures a single amount. Submits via the existing
/// ledger add-entry endpoint — the staff token resolves to the owner vendor.
Future<bool?> showRecordEntrySheet(
  BuildContext context, {
  required EntryType type,
  required List<CustomerLinkItem> customers,
  CustomerLinkItem? preselected,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _RecordEntrySheet(
      type: type,
      customers: customers,
      preselected: preselected,
    ),
  );
}

class _RecordEntrySheet extends StatefulWidget {
  final EntryType type;
  final List<CustomerLinkItem> customers;
  final CustomerLinkItem? preselected;

  const _RecordEntrySheet({
    required this.type,
    required this.customers,
    this.preselected,
  });

  @override
  State<_RecordEntrySheet> createState() => _RecordEntrySheetState();
}

class _RecordEntrySheetState extends State<_RecordEntrySheet> {
  CustomerLinkItem? _customer;
  final _itemCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _submitting = false;

  // Local upload state — NOT via LedgerBloc; this sheet calls the repo directly
  String? _pendingAttachmentUrl;
  bool _uploadingPhoto = false;

  bool get _isDelivery => widget.type == EntryType.credit;

  // Delivery: customer + item name + qty > 0 + price > 0
  // Payment:  customer + amount > 0 + note (description) not empty
  bool get _isSubmitEnabled {
    if (_customer == null) return false;
    if (_submitting || _uploadingPhoto) return false;
    if (_isDelivery) {
      return _itemCtrl.text.trim().isNotEmpty &&
          (double.tryParse(_qtyCtrl.text) ?? 0) > 0 &&
          (double.tryParse(_priceCtrl.text) ?? 0) > 0;
    } else {
      return (double.tryParse(_amountCtrl.text) ?? 0) > 0 &&
          _noteCtrl.text.trim().isNotEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    _customer = widget.preselected;
    _itemCtrl.addListener(_recompute);
    _qtyCtrl.addListener(_recompute);
    _priceCtrl.addListener(_recompute);
    _amountCtrl.addListener(_recompute);
    _noteCtrl.addListener(_recompute);
  }

  @override
  void dispose() {
    _itemCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _recompute() => setState(() {});

  Future<void> _pickAndUpload(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _uploadingPhoto = true);
    try {
      final url = await getIt<LedgerAttachmentService>().uploadAttachment(
        imageFile: File(picked.path),
        linkId: _customer!.linkId,
        entryId: null,
      );
      if (mounted) {
        setState(() {
          _pendingAttachmentUrl = url;
          _uploadingPhoto = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadingPhoto = false);
        AppToast.show(context, AppLocalizations.of(context)!.photoUploadFailedNoError,
            type: ToastType.error);
      }
    }
  }

  double get _deliveryTotal {
    final qty = double.tryParse(_qtyCtrl.text) ?? 0;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    return qty * price;
  }

  double get _amount =>
      _isDelivery ? _deliveryTotal : (double.tryParse(_amountCtrl.text) ?? 0);

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_customer == null) {
      AppToast.show(context, l10n.selectCustomerFirst, type: ToastType.error);
      return;
    }
    if (_amount <= 0) {
      AppToast.show(context, l10n.enterValidAmount, type: ToastType.error);
      return;
    }
    setState(() => _submitting = true);
    try {
      final desc = _isDelivery
          ? (_itemCtrl.text.trim().isEmpty ? null : _itemCtrl.text.trim())
          : (_noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim());
      await getIt<LedgerRepository>().addEntry(
        LedgerEntry(
          id: '',
          linkId: _customer!.linkId,
          amount: _amount,
          type: widget.type,
          date: DateTime.now(),
          description: desc,
          quantity: _isDelivery ? double.tryParse(_qtyCtrl.text) : null,
          status: EntryStatus.pending,
          createdBy: '',
          attachmentUrl: _pendingAttachmentUrl,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
      final l10n = AppLocalizations.of(context)!;
      AppToast.show(
        context,
        _isDelivery
            ? l10n.deliveryRecordedFor(_customer!.displayName)
            : l10n.paymentCollectedFrom(_customer!.displayName),
        type: ToastType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppToast.show(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _isDelivery ? AppColors.error : AppColors.success;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isDelivery
                        ? Icons.local_shipping_rounded
                        : Icons.payments_rounded,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _isDelivery ? l10n.recordDelivery : l10n.collectPayment,
                  style: AppTypography.h3,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _isDelivery ? l10n.addsCredit : l10n.recordsCash,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Customer picker
            _CustomerDropdown(
              customers: widget.customers,
              selected: _customer,
              onChanged: (c) => setState(() => _customer = c),
            ),
            const SizedBox(height: 16),

            if (_isDelivery) ...[
              TextField(
                controller: _itemCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.itemName,
                  hintText: AppLocalizations.of(context)!.itemNameExample,
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.qty,
                        prefixIcon: const Icon(Icons.numbers_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.unitPrice,
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.totalRupees(_deliveryTotal.toStringAsFixed(0)),
                  style: AppTypography.h3.copyWith(color: accent),
                ),
              ),
            ] else ...[
              TextField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.amountRupees,
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  labelText: l10n.descriptionItemDetails,
                  prefixIcon: const Icon(Icons.note_outlined),
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Photo proof — local state only, NOT via LedgerBloc
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: (_uploadingPhoto || _customer == null)
                      ? null
                      : () => _pickAndUpload(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded, size: 16),
                  label: Text(l10n.camera),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: (_uploadingPhoto || _customer == null)
                      ? null
                      : () => _pickAndUpload(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded, size: 16),
                  label: Text(l10n.gallery),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                ),
                if (_uploadingPhoto)
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            ),
            if (_pendingAttachmentUrl != null) ...[
              const SizedBox(height: 10),
              LedgerAttachmentSection(
                attachmentUrl: _pendingAttachmentUrl,
                isLocked: false,
                heroTag: 'staff_new_entry_attachment',
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitEnabled ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _isDelivery
                            ? Icons.local_shipping_rounded
                            : Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                label: Text(
                  _isDelivery ? l10n.deliverAndCharge : l10n.recordPaymentSheet,
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

class _CustomerDropdown extends StatelessWidget {
  final List<CustomerLinkItem> customers;
  final CustomerLinkItem? selected;
  final ValueChanged<CustomerLinkItem?> onChanged;

  const _CustomerDropdown({
    required this.customers,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CustomerLinkItem>(
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.deliverTo,
        prefixIcon: const Icon(Icons.person_search_rounded),
      ),
      items: customers
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(c.displayName, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
