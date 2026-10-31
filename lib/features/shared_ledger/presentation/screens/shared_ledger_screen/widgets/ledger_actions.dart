import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/services/ledger_attachment_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/models/ledger_entry.dart';
import '../../../../../../shared/widgets/app_toast.dart';
import '../../../bloc/ledger_bloc.dart';
import '../../../bloc/ledger_event.dart';
import 'attachment_section.dart';
import 'date_picker_row.dart';
import 'multi_item_entry_sheet.dart';

class LedgerActions extends StatelessWidget {
  final String linkId;
  final String customerName;
  final bool isVendorView;

  const LedgerActions({
    super.key,
    required this.linkId,
    required this.customerName,
    this.isVendorView = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () =>
                  _showAddEntrySheet(context, l10n, EntryType.payment),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
                side: const BorderSide(color: AppColors.success),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.arrow_downward_rounded, size: 18),
              label: Text(l10n.recordPayment),
            ),
          ),
          if (isVendorView) ...[
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showMultiItemEntrySheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(
                  Icons.arrow_upward_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  l10n.giveCredit,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMultiItemEntrySheet(BuildContext context) {
    final bloc = context.read<LedgerBloc>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: MultiItemEntrySheet(linkId: linkId, customerName: customerName),
      ),
    );
  }

  void _showAddEntrySheet(
    BuildContext context,
    AppLocalizations l10n,
    EntryType type,
  ) {
    final bloc = context.read<LedgerBloc>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _AddEntrySheet(
        bloc: bloc,
        type: type,
        linkId: linkId,
        customerName: customerName,
        l10n: l10n,
      ),
    );
  }
}

class _AddEntrySheet extends StatefulWidget {
  final LedgerBloc bloc;
  final EntryType type;
  final String linkId;
  final String customerName;
  final AppLocalizations l10n;

  const _AddEntrySheet({
    required this.bloc,
    required this.type,
    required this.linkId,
    required this.customerName,
    required this.l10n,
  });

  @override
  State<_AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<_AddEntrySheet> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  String? _pendingUrl;
  bool _uploading = false;
  DateTime? _selectedDate;

  bool get _isSubmitEnabled {
    if (_uploading) return false;
    return (double.tryParse(_amountCtrl.text) ?? 0) > 0 &&
        _descCtrl.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _amountCtrl.addListener(_rebuild);
    _descCtrl.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);
    try {
      final url = await getIt<LedgerAttachmentService>().uploadAttachment(
        imageFile: File(picked.path),
        linkId: widget.linkId,
        entryId: null,
      );
      if (mounted) {
        setState(() {
          _pendingUrl = url;
          _uploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploading = false);
        AppToast.show(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final type = widget.type;
    final mq = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom: mq.viewInsets.bottom + mq.viewPadding.bottom + 24,
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
                    color:
                        (type == EntryType.credit
                                ? AppColors.error
                                : AppColors.success)
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    type == EntryType.credit
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: type == EntryType.credit
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type == EntryType.credit
                      ? l10n.giveCreditSheet
                      : l10n.recordPaymentSheet,
                  style: AppTypography.h3,
                ),
              ],
            ),
            Text(
              l10n.entryFor(widget.customerName),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              decoration: InputDecoration(
                labelText: l10n.description,
                prefixIcon: const Icon(Icons.description_rounded),
                hintText: l10n.descriptionHint,
              ),
            ),
            const SizedBox(height: 16),
            LedgerDatePickerRow(
              selectedDate: _selectedDate,
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? now,
                  firstDate: DateTime(now.year - 1, now.month, now.day),
                  lastDate: now,
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.quantityOptional,
                prefixIcon: const Icon(Icons.numbers_rounded),
                hintText: l10n.quantityHint,
              ),
            ),
            const SizedBox(height: 16),
            // Photo proof buttons
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _uploading
                      ? null
                      : () => _pickAndUpload(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded, size: 16),
                  label: Text(l10n.camera),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _uploading
                      ? null
                      : () => _pickAndUpload(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded, size: 16),
                  label: Text(l10n.gallery),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                  ),
                ),
                if (_uploading) ...[
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            if (_pendingUrl != null) ...[
              const SizedBox(height: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  LedgerAttachmentSection(
                    attachmentUrl: _pendingUrl,
                    isLocked: false,
                    heroTag: 'new_entry_attachment_${widget.linkId}',
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => setState(() => _pendingUrl = null),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitEnabled
                    ? () {
                        Navigator.pop(context);
                        widget.bloc.add(
                          AddLedgerEntry(
                            amount: double.parse(_amountCtrl.text),
                            type: type,
                            linkId: widget.linkId,
                            description: _descCtrl.text.trim(),
                            quantity: double.tryParse(_qtyCtrl.text),
                            attachmentUrl: _pendingUrl,
                            date: _selectedDate,
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == EntryType.credit
                      ? AppColors.error
                      : AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  type == EntryType.credit
                      ? l10n.addCreditEntry
                      : l10n.recordPayment,
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
