import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/link_model.dart';
import '../../../../shared/models/product_template.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import '../../../vendor/presentation/bloc/vendor_bloc.dart';
import '../../../vendor/presentation/bloc/vendor_state.dart';
import '../../data/repositories/template_repository.dart';
import '../cubit/bulk_charge_cubit.dart';

class BulkChargeScreen extends StatelessWidget {
  const BulkChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BulkChargeCubit(
            getIt<TemplateRepository>(),
            getIt<ScheduleRepository>(),
          )..loadTemplates(),
        ),
        BlocProvider.value(value: getIt<VendorBloc>()),
      ],
      child: const _BulkChargeView(),
    );
  }
}

class _BulkChargeView extends StatelessWidget {
  const _BulkChargeView();

  @override
  Widget build(BuildContext context) {
    final vendorState = context.watch<VendorBloc>().state;
    final customers = vendorState is VendorLoaded
        ? vendorState.customers
        : <CustomerLinkItem>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bulkCharge),
        actions: [
          IconButton(
            onPressed: () => _showCreateTemplateSheet(context),
            icon: const Icon(Icons.add_rounded),
            tooltip: AppLocalizations.of(context)!.newProduct,
          ),
        ],
      ),
      body: BlocConsumer<BulkChargeCubit, BulkChargeState>(
        listenWhen: (_, curr) =>
            curr.templateError != null || curr.submitError != null,
        listener: (context, state) {
          final err = state.submitError ?? state.templateError;
          if (err != null) {
            AppToast.show(context, err, type: ToastType.error);
          }
        },
        builder: (context, state) {
          if (state.templatesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.templates.isEmpty) {
            return _EmptyTemplates(
              onAdd: () => _showCreateTemplateSheet(context),
            );
          }

          return Column(
            children: [
              // ── Template picker ──────────────────────────────────────────
              _TemplatePicker(
                templates: state.templates,
                selected: state.selectedTemplate,
                onSelect: (t) => _selectTemplate(context, t),
                onEdit: (t) => _showTemplateSheet(context, existing: t),
                onDelete: (t) =>
                    context.read<BulkChargeCubit>().deleteTemplate(t.id),
              ),
              if (state.selectedTemplate != null &&
                  !state.selectedTemplate!.needsPricing) ...[
                _TemplateInfoBar(template: state.selectedTemplate!),
                const Divider(height: 1),
                // ── Customer quantity grid ───────────────────────────────
                Expanded(
                  child: customers.isEmpty
                      ? const _NoCustomers()
                      : _CustomerGrid(
                          customers: customers,
                          quantities: state.quantities,
                          unit: state.selectedTemplate!.unit!,
                          pricePerUnit: state.selectedTemplate!.pricePerUnit!,
                        ),
                ),
              ] else if (state.selectedTemplate != null &&
                  state.selectedTemplate!.needsPricing)
                Expanded(
                  child: _NeedsPricingHint(
                    template: state.selectedTemplate!,
                    onSetPrice: () =>
                        _showPriceServiceSheet(context, state.selectedTemplate!),
                  ),
                )
              else
                const Expanded(child: _SelectTemplateHint()),
            ],
          );
        },
      ),
      bottomNavigationBar: _BottomBar(customers: customers),
    );
  }

  void _showCreateTemplateSheet(BuildContext context) =>
      _showTemplateSheet(context, existing: null);

  void _selectTemplate(BuildContext context, ProductTemplate t) {
    context.read<BulkChargeCubit>().selectTemplate(t);
    if (t.needsPricing) _showPriceServiceSheet(context, t);
  }

  void _showPriceServiceSheet(BuildContext context, ProductTemplate template) {
    final cubit = context.read<BulkChargeCubit>();
    final unitCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom:
                MediaQuery.of(ctx).viewInsets.bottom +
                MediaQuery.of(ctx).viewPadding.bottom +
                32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(template.name, style: AppTypography.h3),
              const SizedBox(height: 4),
              Text(
                l10n.defineProduct,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: unitCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: l10n.unit,
                        hintText: l10n.unitExample,
                        prefixIcon: const Icon(Icons.straighten_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.pricePerUnit,
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final unit = unitCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text);
                    if (unit.isEmpty || price == null || price <= 0) return;
                    final ok = await cubit.priceScheduleService(
                      template,
                      unit: unit,
                      pricePerUnit: price,
                    );
                    if (ok && ctx.mounted) Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    l10n.saveChanges,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTemplateSheet(
    BuildContext context, {
    required ProductTemplate? existing,
  }) {
    final cubit = context.read<BulkChargeCubit>();
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final unitCtrl = TextEditingController(text: existing?.unit ?? '');
    final priceCtrl = TextEditingController(
      text: existing?.pricePerUnit?.toStringAsFixed(2) ?? '',
    );
    final isEdit = existing != null;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            // viewInsets clears the keyboard; viewPadding clears the gesture
            // bar / 3-button nav when the keyboard is closed.
            bottom:
                MediaQuery.of(ctx).viewInsets.bottom +
                MediaQuery.of(ctx).viewPadding.bottom +
                32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? l10n.editProduct : l10n.newProductService,
                style: AppTypography.h3,
              ),
              const SizedBox(height: 4),
              Text(
                isEdit ? l10n.updateProductDetails : l10n.defineProduct,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                textCapitalization: TextCapitalization.words,
                autofocus: !isEdit,
                decoration: InputDecoration(
                  labelText: l10n.productName,
                  hintText: l10n.productNameExample,
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: unitCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.unit,
                        hintText: l10n.unitExample,
                        prefixIcon: const Icon(Icons.straighten_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.pricePerUnit,
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final unit = unitCtrl.text.trim();
                    final price = double.tryParse(priceCtrl.text);
                    if (name.isEmpty ||
                        unit.isEmpty ||
                        price == null ||
                        price <= 0) {
                      return;
                    }
                    Navigator.pop(ctx);
                    if (isEdit) {
                      cubit.updateTemplate(
                        id: existing.id,
                        name: name,
                        unit: unit,
                        pricePerUnit: price,
                      );
                    } else {
                      cubit.createTemplate(
                        name: name,
                        unit: unit,
                        pricePerUnit: price,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isEdit ? l10n.saveChanges : l10n.saveProduct,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Template Picker ──────────────────────────────────────────────────────────

/// One picker entry — either a standalone bulk-charge template, or a
/// schedule service represented by all of its (active) items grouped
/// together, so a multi-item bundle shows as one card instead of one chip
/// per item.
class _PickerEntry {
  final ProductTemplate? template; // set for standalone templates
  final String? serviceId; // set for schedule-service groups
  final String? serviceName;
  final List<ProductTemplate> serviceItems;

  const _PickerEntry.template(ProductTemplate t)
      : template = t,
        serviceId = null,
        serviceName = null,
        serviceItems = const [];

  const _PickerEntry.service(this.serviceId, this.serviceName, this.serviceItems)
      : template = null;

  bool get isService => serviceId != null;
  bool get isMultiItem => isService && serviceItems.length > 1;
}

class _TemplatePicker extends StatelessWidget {
  final List<ProductTemplate> templates;
  final ProductTemplate? selected;
  final ValueChanged<ProductTemplate> onSelect;
  final ValueChanged<ProductTemplate> onEdit;
  final ValueChanged<ProductTemplate> onDelete;

  const _TemplatePicker({
    required this.templates,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  List<_PickerEntry> _buildEntries() {
    final entries = <_PickerEntry>[];
    final seenServices = <String>{};
    for (final t in templates) {
      if (!t.isScheduleService) {
        entries.add(_PickerEntry.template(t));
        continue;
      }
      final serviceId = t.scheduleServiceId;
      if (serviceId == null || !seenServices.add(serviceId)) continue;
      final items = templates
          .where((o) => o.isScheduleService && o.scheduleServiceId == serviceId)
          .toList();
      entries.add(_PickerEntry.service(serviceId, t.scheduleServiceName, items));
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries();
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final entry = entries[i];
          if (!entry.isService) {
            final t = entry.template!;
            final isSelected = t.id == selected?.id;
            return GestureDetector(
              onLongPress: () => _showActions(context, t),
              child: ChoiceChip(
                label: Text(t.name),
                selected: isSelected,
                onSelected: (_) => onSelect(t),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          // Single-item service: behaves like a direct-select chip, no
          // extra tap to open a one-item card.
          if (!entry.isMultiItem) {
            final t = entry.serviceItems.first;
            final isSelected = t.id == selected?.id;
            return ChoiceChip(
              avatar: const Icon(Icons.event_repeat_rounded, size: 16),
              label: Text(entry.serviceName ?? t.name),
              selected: isSelected,
              onSelected: (_) => onSelect(t),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.w600,
              ),
            );
          }

          // Multi-item bundle: tapping opens a small card to pick one item.
          final isSelected = entry.serviceItems.any((t) => t.id == selected?.id);
          return ChoiceChip(
            avatar: const Icon(Icons.event_repeat_rounded, size: 16),
            label: Text('${entry.serviceName} (${entry.serviceItems.length})'),
            selected: isSelected,
            onSelected: (_) => _showItemPicker(context, entry),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  void _showItemPicker(BuildContext context, _PickerEntry entry) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          // Cap the card's height on small screens instead of letting a
          // long item list push past the visible area.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_repeat_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.serviceName ?? '',
                        style: AppTypography.h3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.bulkChargePickOneItem,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Divider(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: entry.serviceItems.length,
                  itemBuilder: (_, i) {
                    final item = entry.serviceItems[i];
                    final isSelected = item.id == selected?.id;
                    return ListTile(
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textHint,
                      ),
                      title: Text(item.name),
                      trailing: item.needsPricing
                          ? const Icon(Icons.price_change_outlined,
                              size: 18, color: AppColors.warning)
                          : Text(
                              AppLocalizations.of(context)!.pricePerUnitValue(
                                item.pricePerUnit!.toStringAsFixed(2),
                                item.unit ?? '',
                              ),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                      onTap: () {
                        Navigator.pop(ctx);
                        onSelect(item);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context, ProductTemplate t) {
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
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.name,
                      style: AppTypography.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₹${t.pricePerUnit?.toStringAsFixed(2) ?? '—'} / ${t.unit ?? '—'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.editProductMenuItem),
              onTap: () {
                Navigator.pop(ctx);
                onEdit(t);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: Text(
                AppLocalizations.of(context)!.deleteProductMenuItem,
                style: const TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, t);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductTemplate t) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l10n.deleteProductConfirmation),
          content: Text(l10n.removeProductConfirmation(t.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDelete(t);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}

// ─── Template Info Bar ────────────────────────────────────────────────────────

class _TemplateInfoBar extends StatelessWidget {
  final ProductTemplate template;
  const _TemplateInfoBar({required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.primary.withValues(alpha: 0.06),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              template.scheduleServiceName != null
                  ? '${template.scheduleServiceName} · ${template.name}'
                  : template.name,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text('•', style: AppTypography.bodySmall),
          const SizedBox(width: 8),
          Text(
            '₹${template.pricePerUnit!.toStringAsFixed(2)} / ${template.unit}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Needs Pricing Hint ───────────────────────────────────────────────────────

class _NeedsPricingHint extends StatelessWidget {
  final ProductTemplate template;
  final VoidCallback onSetPrice;
  const _NeedsPricingHint({required this.template, required this.onSetPrice});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.price_change_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.setPriceToChargeTitle(template.name),
              textAlign: TextAlign.center,
              style: AppTypography.h3,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.setPriceToChargeSubtitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onSetPrice,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.price_change_outlined, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.setPrice,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Customer Quantity Grid ───────────────────────────────────────────────────

class _CustomerGrid extends StatelessWidget {
  final List<CustomerLinkItem> customers;
  final Map<String, double> quantities;
  final String unit;
  final double pricePerUnit;

  const _CustomerGrid({
    required this.customers,
    required this.quantities,
    required this.unit,
    required this.pricePerUnit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight + 12,
      ),
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final c = customers[i];
        final qty = quantities[c.linkId] ?? 0;
        return _CustomerQtyRow(
          customer: c,
          quantity: qty,
          unit: unit,
          pricePerUnit: pricePerUnit,
          onChanged: (newQty) =>
              context.read<BulkChargeCubit>().setQuantity(c.linkId, newQty),
        );
      },
    );
  }
}

class _CustomerQtyRow extends StatelessWidget {
  final CustomerLinkItem customer;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final ValueChanged<double> onChanged;

  const _CustomerQtyRow({
    required this.customer,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasQty = quantity > 0;
    final amount = quantity * pricePerUnit;
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: hasQty
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: hasQty
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.15),
            child: Text(
              customer.displayName[0].toUpperCase(),
              style: TextStyle(
                color: hasQty ? AppColors.primary : AppColors.textHint,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + qty label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.displayName,
                  style: AppTypography.labelLarge.copyWith(
                    color: hasQty ? null : AppColors.textHint,
                  ),
                ),
                Text(
                  '${quantity.toStringAsFixed(quantity % 1 == 0 ? 0 : 1)} $unit',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Stepper
          _Stepper(
            value: quantity,
            onDecrement: () => onChanged((quantity - 1).clamp(0, 9999)),
            onIncrement: () => onChanged(quantity + 1),
          ),
          // Amount
          SizedBox(
            width: 60,
            child: Text(
              hasQty ? '= ₹${amount.toStringAsFixed(0)}' : '= ₹0',
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge.copyWith(
                color: hasQty ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final double value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _Stepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final hasQty = value > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(
          icon: Icons.remove,
          onTap: hasQty ? onDecrement : null,
          filled: false,
        ),
        SizedBox(
          width: 32,
          child: Text(
            value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
            textAlign: TextAlign.center,
            style: AppTypography.labelLarge,
          ),
        ),
        _StepBtn(icon: Icons.add, onTap: onIncrement, filled: true),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _StepBtn({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled && onTap != null
              ? AppColors.primary
              : Colors.transparent,
          border: Border.all(
            color: onTap != null ? AppColors.primary : AppColors.textHint,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled && onTap != null
              ? Colors.white
              : onTap != null
              ? AppColors.primary
              : AppColors.textHint,
        ),
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final List<CustomerLinkItem> customers;
  const _BottomBar({required this.customers});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkChargeCubit, BulkChargeState>(
      builder: (context, state) {
        final template = state.selectedTemplate;
        if (template == null || template.needsPricing) {
          return const SizedBox.shrink();
        }

        final total = state.totalAmount(template.pricePerUnit!);
        final count = state.activeCustomerCount;
        final hasItems = count > 0;

        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).viewPadding.bottom + 12,
          ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        final qty = state.quantities.values
                            .fold(0.0, (s, q) => s + q)
                            .toStringAsFixed(1);
                        return Text(
                          count == 1
                              ? l10n.bulkSummaryLine(count, qty, template.unit!)
                              : l10n.bulkSummaryLinePlural(
                                  count,
                                  qty,
                                  template.unit!,
                                ),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.totalAmount(total.toStringAsFixed(0)),
                      style: AppTypography.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: hasItems && !state.isSubmitting
                    ? () => _submit(context, customers)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                icon: state.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                label: Text(
                  AppLocalizations.of(context)!.chargeAll,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: state.isSubmitting ? 13 : 15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(
    BuildContext context,
    List<CustomerLinkItem> customers,
  ) async {
    final cubit = context.read<BulkChargeCubit>();
    final result = await cubit.submitCharge(customers);
    if (!context.mounted || result == null) return;

    final ok = result.succeeded.length;
    final fail = result.failed.length;

    final l10n = AppLocalizations.of(context)!;
    if (fail == 0) {
      AppToast.show(
        context,
        ok == 1
            ? l10n.chargedSuccessfully(ok)
            : l10n.chargedSuccessfullyPlural(ok),
        type: ToastType.success,
      );
    } else {
      AppToast.show(
        context,
        l10n.chargedPartial(ok, fail),
        type: fail == ok + fail ? ToastType.error : ToastType.success,
      );
    }
  }
}

// ─── Empty / hint states ──────────────────────────────────────────────────────

class _EmptyTemplates extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyTemplates({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noProductsYet,
              style: AppTypography.h3,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noProductsYetDescription,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.addFirstProduct,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectTemplateHint extends StatelessWidget {
  const _SelectTemplateHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.selectProductToAssignQty,
        style: const TextStyle(color: AppColors.textHint),
      ),
    );
  }
}

class _NoCustomers extends StatelessWidget {
  const _NoCustomers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.noCustomersLinked,
        style: const TextStyle(color: AppColors.textHint),
      ),
    );
  }
}
