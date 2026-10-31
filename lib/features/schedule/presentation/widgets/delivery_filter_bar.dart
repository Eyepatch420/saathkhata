import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/localization/localized_labels.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/schedule_model.dart';
import '../../domain/models/delivery_filter.dart';

/// Filter bar for a delivery list (staff "Today's Deliveries" and vendor
/// Schedule tab). Mirrors [LedgerFilterBar]'s icon+chips → bottom-sheet
/// pattern for visual consistency, but is driven by a plain callback rather
/// than a bloc event since [DeliveriesCubit] is a Cubit with no filter state.
class DeliveryFilterBar extends StatelessWidget {
  final DeliveryFilter filter;
  final ValueChanged<DeliveryFilter> onChanged;

  const DeliveryFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActiveFilters = !filter.isEmpty;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          InkWell(
            onTap: () => _showFilterSheet(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: hasActiveFilters
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasActiveFilters
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: hasActiveFilters
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  if (hasActiveFilters) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${filter.activeCount}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (!hasActiveFilters)
                    Text(
                      l10n.allDeliveriesFilter,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    )
                  else ...[
                    if (filter.status != null) ...[
                      _ActiveChip(
                        label: l10n.deliveryStatusName(filter.status!),
                        onRemove: () =>
                            onChanged(filter.copyWith(clearStatus: true)),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (filter.date != null) ...[
                      _ActiveChip(
                        label: DateFormat('d MMM').format(filter.date!),
                        onRemove: () =>
                            onChanged(filter.copyWith(clearDate: true)),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (filter.nameQuery != null &&
                        filter.nameQuery!.isNotEmpty) ...[
                      _ActiveChip(
                        label: '"${filter.nameQuery}"',
                        onRemove: () =>
                            onChanged(filter.copyWith(clearName: true)),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (filter.radiusKm != null) ...[
                      _ActiveChip(
                        label: l10n.withinKmLabel(
                          filter.radiusKm!.toStringAsFixed(0),
                        ),
                        onRemove: () =>
                            onChanged(filter.copyWith(clearRadius: true)),
                      ),
                      const SizedBox(width: 6),
                    ],
                    GestureDetector(
                      onTap: () => onChanged(const DeliveryFilter()),
                      child: Text(
                        l10n.clearAllFilters,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _FilterSheet(current: filter, onApply: onChanged),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final DeliveryFilter current;
  final ValueChanged<DeliveryFilter> onApply;
  const _FilterSheet({required this.current, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late DeliveryStatus? _status;
  late DateTime? _date;
  late TextEditingController _nameCtrl;
  double? _radiusKm;
  double? _centerLat;
  double? _centerLng;
  bool _locating = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _status = widget.current.status;
    _date = widget.current.date;
    _nameCtrl = TextEditingController(text: widget.current.nameQuery ?? '');
    _radiusKm = widget.current.radiusKm;
    _centerLat = widget.current.centerLat;
    _centerLng = widget.current.centerLng;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickRadius(double km) async {
    final l10n = AppLocalizations.of(context)!;
    if (_centerLat == null || _centerLng == null) {
      setState(() => _locating = true);
      try {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _locating = false;
            _locationError = l10n.locationPermissionDenied;
          });
          return;
        }
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
        if (!mounted) return;
        setState(() {
          _centerLat = pos.latitude;
          _centerLng = pos.longitude;
          _radiusKm = km;
          _locating = false;
          _locationError = null;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _locating = false;
          _locationError = l10n.couldNotGetCurrentLocation;
        });
      }
    } else {
      setState(() => _radiusKm = km);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(l10n.filterDeliveriesTitle, style: AppTypography.h3),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onApply(const DeliveryFilter());
                    },
                    child: Text(l10n.resetLabel),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(l10n.filterCustomerServiceName, style: _sectionStyle()),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: l10n.filterSearchByName,
                  isDense: true,
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                ),
              ),
              const SizedBox(height: 16),

              Text(l10n.statusLabel.toUpperCase(), style: _sectionStyle()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _OptionChip(
                    label: l10n.filterAll,
                    selected: _status == null,
                    onTap: () => setState(() => _status = null),
                  ),
                  for (final s in DeliveryStatus.values)
                    _OptionChip(
                      label: l10n.deliveryStatusName(s),
                      selected: _status == s,
                      onTap: () =>
                          setState(() => _status = _status == s ? null : s),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              Text(l10n.date.toUpperCase(), style: _sectionStyle()),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _DateButton(
                      label: _date == null
                          ? l10n.filterAnyDate
                          : DateFormat('EEE, d MMM').format(_date!),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date ?? now,
                          firstDate: DateTime(now.year - 1),
                          lastDate: DateTime(now.year + 1),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                    ),
                  ),
                  if (_date != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => setState(() => _date = null),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              Text(l10n.filterRadiusFromLocation, style: _sectionStyle()),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final km in [1.0, 3.0, 5.0, 10.0])
                    _OptionChip(
                      label: l10n.kmLabel(km.toStringAsFixed(0)),
                      selected: _radiusKm == km,
                      onTap: _locating
                          ? () {}
                          : () => _radiusKm == km
                                ? setState(() {
                                    _radiusKm = null;
                                    _centerLat = null;
                                    _centerLng = null;
                                  })
                                : _pickRadius(km),
                    ),
                  if (_locating)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              if (_locationError != null) ...[
                const SizedBox(height: 6),
                Text(
                  _locationError!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ],
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(
                      DeliveryFilter(
                        status: _status,
                        date: _date,
                        nameQuery: _nameCtrl.text.trim().isEmpty
                            ? null
                            : _nameCtrl.text.trim(),
                        radiusKm: _radiusKm,
                        centerLat: _centerLat,
                        centerLng: _centerLng,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    l10n.applyFilterButton,
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
      ),
    );
  }

  TextStyle _sectionStyle() => AppTypography.bodySmall.copyWith(
    color: AppColors.textHint,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DateButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}
