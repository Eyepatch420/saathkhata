import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/link_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/repositories/vendor_repository.dart';

/// Sheet for vendor to set default delivery product/qty for a specific customer.
/// Pre-fills with existing defaults if set.
class CustomerDefaultsSheet extends StatefulWidget {
  final CustomerLinkItem customer;
  final void Function({
    required String? product,
    required String? unit,
    required double? qty,
    required double? price,
  })?
  onSaved;

  const CustomerDefaultsSheet({
    super.key,
    required this.customer,
    this.onSaved,
  });

  @override
  State<CustomerDefaultsSheet> createState() => _CustomerDefaultsSheetState();
}

class _CustomerDefaultsSheetState extends State<CustomerDefaultsSheet> {
  late final TextEditingController _productCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _priceCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _productCtrl = TextEditingController(text: c.defaultProduct ?? '');
    _unitCtrl = TextEditingController(text: c.defaultUnit ?? '');
    _qtyCtrl = TextEditingController(
      text: c.defaultQty != null
          ? c.defaultQty!.toStringAsFixed(c.defaultQty! % 1 == 0 ? 0 : 2)
          : '',
    );
    _priceCtrl = TextEditingController(
      text: c.defaultPricePerUnit != null
          ? c.defaultPricePerUnit!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _productCtrl.dispose();
    _unitCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final product = _productCtrl.text.trim();
    final unit = _unitCtrl.text.trim();
    final qty = double.tryParse(_qtyCtrl.text);
    final price = double.tryParse(_priceCtrl.text);

    setState(() => _saving = true);
    try {
      await getIt<VendorRepository>().updateLinkDefaults(
        widget.customer.linkId,
        defaultProduct: product.isEmpty ? null : product,
        defaultUnit: unit.isEmpty ? null : unit,
        defaultQty: qty,
        defaultPricePerUnit: price,
      );
      if (mounted) {
        Navigator.pop(context);
        AppToast.show(
          context,
          AppLocalizations.of(context)!.defaultDeliverySaved,
          type: ToastType.success,
        );
        widget.onSaved?.call(
          product: product.isEmpty ? null : product,
          unit: unit.isEmpty ? null : unit,
          qty: qty,
          price: price,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
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
    final name = widget.customer.displayName;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        // viewInsets clears the keyboard; viewPadding clears the gesture bar
        // / 3-button nav when the keyboard is closed.
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.defaultDeliveryTitle,
              style: AppTypography.h3),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.defaultDeliveryPrefillHint(name),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _productCtrl,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.productName,
              prefixIcon: const Icon(Icons.inventory_2_outlined),
              hintText: AppLocalizations.of(context)!.fullCreamMilkExample,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.defaultQtyLabel,
                    prefixIcon: const Icon(Icons.numbers_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _unitCtrl,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.unit,
                    hintText: AppLocalizations.of(context)!.unitExampleHint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pricePerUnit,
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.saveDefaultsButton,
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
