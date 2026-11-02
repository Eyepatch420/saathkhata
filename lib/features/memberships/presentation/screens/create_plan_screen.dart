import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/models/membership_plan.dart';
import '../bloc/plans_cubit.dart';
import '../membership_theme.dart';

class CreatePlanScreen extends StatefulWidget {
  final MembershipPlan? existing;
  const CreatePlanScreen({super.key, this.existing});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _BenefitRow {
  final TextEditingController labelCtrl;
  final TextEditingController quotaCtrl;
  _BenefitRow({String label = '', int? quota})
      : labelCtrl = TextEditingController(text: label),
        quotaCtrl = TextEditingController(text: quota?.toString() ?? '');
  void dispose() {
    labelCtrl.dispose();
    quotaCtrl.dispose();
  }
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '30');
  final _priceCtrl = TextEditingController();
  final _customAdvanceCtrl = TextEditingController();
  final List<_BenefitRow> _benefits = [];

  double _advance = 0;
  bool _customAdvance = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _nameCtrl.text = e.name;
      _durationCtrl.text = e.durationDays.toString();
      _priceCtrl.text = e.price.toStringAsFixed(0);
      _advance = e.advanceRequired;
      if (e.advanceRequired != 0 &&
          e.advanceRequired != 200 &&
          e.advanceRequired != 500) {
        _customAdvance = true;
        _customAdvanceCtrl.text = e.advanceRequired.toStringAsFixed(0);
      }
      for (final b in e.benefits) {
        _benefits.add(_BenefitRow(label: b.label, quota: b.quota));
      }
    }
    if (_benefits.isEmpty) _benefits.add(_BenefitRow());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _durationCtrl.dispose();
    _priceCtrl.dispose();
    _customAdvanceCtrl.dispose();
    for (final b in _benefits) {
      b.dispose();
    }
    super.dispose();
  }

  double get _effectiveAdvance {
    if (_customAdvance) {
      return double.tryParse(_customAdvanceCtrl.text.trim()) ?? 0;
    }
    return _advance;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final benefits = _benefits
        .where((b) => b.labelCtrl.text.trim().isNotEmpty)
        .map((b) => PlanBenefit(
              id: '',
              label: b.labelCtrl.text.trim(),
              quota: int.tryParse(b.quotaCtrl.text.trim()),
            ))
        .toList();

    final cubit = context.read<PlansCubit>();
    final ok = _isEdit
        ? await cubit.updatePlan(
            widget.existing!.id,
            name: _nameCtrl.text.trim(),
            durationDays: int.parse(_durationCtrl.text.trim()),
            price: double.parse(_priceCtrl.text.trim()),
            advanceRequired: _effectiveAdvance,
            benefits: benefits,
          )
        : await cubit.createPlan(
            name: _nameCtrl.text.trim(),
            durationDays: int.parse(_durationCtrl.text.trim()),
            price: double.parse(_priceCtrl.text.trim()),
            advanceRequired: _effectiveAdvance,
            benefits: benefits,
          );

    if (!mounted) return;
    if (ok) {
      final l10n = AppLocalizations.of(context)!; // ignore: use_build_context_synchronously
      AppToast.show(context, _isEdit ? l10n.planUpdatedToast : l10n.planPublishedToast);
      Navigator.pop(context);
    } else {
      final s = cubit.state;
      if (s is PlansError) AppToast.show(context, s.message, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editPlanTitle : l10n.createPlanTitle),
        backgroundColor: MembershipTheme.purple,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          children: [
            _SectionLabel(l10n.planDetailsSection),
            const SizedBox(height: 8),
            _Card(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.planNameLabel,
                      hintText: l10n.planNameHint,
                      prefixIcon: const Icon(Icons.workspace_premium_outlined),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.required : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _durationCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.durationDaysLabel,
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                          ),
                          validator: (v) {
                            final n = int.tryParse(v?.trim() ?? '');
                            if (n == null || n < 1) return 'Min 1';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _priceCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'))
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.priceRupeesLabel,
                            prefixIcon: const Icon(Icons.currency_rupee_rounded),
                          ),
                          validator: (v) {
                            final n = double.tryParse(v?.trim() ?? '');
                            if (n == null || n < 0) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(l10n.benefitsSection),
            const SizedBox(height: 8),
            _Card(
              isDark: isDark,
              child: Column(
                children: [
                  ...List.generate(_benefits.length, (i) => _benefitRow(i, l10n)),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          setState(() => _benefits.add(_BenefitRow())),
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: Text(l10n.addBenefitButton),
                      style: TextButton.styleFrom(
                          foregroundColor: MembershipTheme.purple),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel(l10n.advanceRequiredSection),
            const SizedBox(height: 8),
            _Card(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _advanceChip(l10n.none, 0),
                      _advanceChip('₹200', 200),
                      _advanceChip('₹500', 500),
                      ChoiceChip(
                        label: Text(l10n.customLabel),
                        selected: _customAdvance,
                        selectedColor:
                            MembershipTheme.purple.withValues(alpha: 0.15),
                        checkmarkColor: MembershipTheme.purple,
                        labelStyle: TextStyle(
                          color: _customAdvance
                              ? MembershipTheme.purple
                              : null,
                          fontWeight: _customAdvance
                              ? FontWeight.w600
                              : null,
                        ),
                        onSelected: (_) =>
                            setState(() => _customAdvance = true),
                      ),
                    ],
                  ),
                  if (_customAdvance) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _customAdvanceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.customAdvanceLabel,
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<PlansCubit, PlansState>(
        builder: (context, state) {
          final saving = state is PlansLoaded && state.saving;
          final l10nInner = AppLocalizations.of(context)!;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                onPressed: saving ? null : _submit,
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.publish_rounded),
                label: Text(_isEdit ? l10nInner.saveChanges : l10nInner.publishPlanButton),
                style: FilledButton.styleFrom(
                  backgroundColor: MembershipTheme.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _benefitRow(int i, AppLocalizations l10n) {
    final row = _benefits[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Icon(Icons.check_circle_rounded,
                size: 18, color: AppColors.success),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: row.labelCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.benefitLabel,
                hintText: l10n.benefitHint,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: row.quotaCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l10n.qty),
              textAlign: TextAlign.center,
            ),
          ),
          if (_benefits.length > 1)
            IconButton(
              icon: const Icon(Icons.close_rounded,
                  size: 18, color: AppColors.error),
              onPressed: () => setState(() {
                _benefits[i].dispose();
                _benefits.removeAt(i);
              }),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _advanceChip(String label, double value) {
    final selected = !_customAdvance && _advance == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: MembershipTheme.purple.withValues(alpha: 0.15),
      checkmarkColor: MembershipTheme.purple,
      labelStyle: TextStyle(
        color: selected ? MembershipTheme.purple : null,
        fontWeight: selected ? FontWeight.w600 : null,
      ),
      onSelected: (_) => setState(() {
        _customAdvance = false;
        _advance = value;
      }),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _Card({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
