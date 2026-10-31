import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/link_model.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/vendor_tile.dart';

class MyKhatasScreen extends StatefulWidget {
  const MyKhatasScreen({super.key});

  @override
  State<MyKhatasScreen> createState() => _MyKhatasScreenState();
}

class _MyKhatasScreenState extends State<MyKhatasScreen> {
  String? _activeCategory;

  /// Short, localized chip label for a vendor's stored business category.
  String _chipLabel(AppLocalizations l10n, String cat) => switch (cat) {
        'Milk / Dairy' => l10n.categoryShortDairy,
        'Press / Dhobi' => l10n.categoryShortPress,
        'Maid / Cook' => l10n.categoryShortMaid,
        'Newspaper' => l10n.categoryShortNews,
        'Water Can' => l10n.categoryShortWater,
        'Tiffin / Food' => l10n.categoryShortTiffin,
        'Kirana / Grocery' => l10n.categoryShortKirana,
        'Salon / Parlour' => l10n.categoryShortSalon,
        'Construction Labour' => l10n.categoryShortLabour,
        'Transport / Auto' => l10n.categoryShortTransport,
        'Gym / Fitness' => l10n.categoryShortGym,
        _ => cat,
      };

  Map<String, List<VendorLinkItem>> _groupByCategory(List<VendorLinkItem> vendors) {
    final groups = <String, List<VendorLinkItem>>{};
    for (final item in vendors) {
      final cat = item.vendor.primaryCategory ?? 'Other';
      groups.putIfAbsent(cat, () => []).add(item);
    }
    return groups;
  }

  List<String> _sortedCategories(Map<String, List<VendorLinkItem>> groups) {
    final cats = groups.keys.toList();
    cats.sort((a, b) {
      if (a == 'Other') return 1;
      if (b == 'Other') return -1;
      return a.compareTo(b);
    });
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => CustomerBloc(getIt())..add(LoadCustomerDashboard()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myKhatas),
        ),
        body: SafeArea(
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CustomerLoaded) {
                final active = state.vendors.where((v) => !v.isPending).toList();
                final pending = state.vendors.where((v) => v.isPending).toList();
                final allVendors = [...active, ...pending];

                if (allVendors.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.noVendorsFound));
                }

                final groups = _groupByCategory(active);
                final categories = _sortedCategories(groups);
                final hasMultipleCategories = categories.length > 1;

                return Column(
                  children: [
                    if (hasMultipleCategories)
                      _CategoryFilterRow(
                        categories: categories,
                        activeCategory: _activeCategory,
                        chipLabel: (cat) => _chipLabel(l10n, cat),
                        onSelect: (cat) => setState(() => _activeCategory = cat),
                      ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                            20, 20, 20, MediaQuery.of(context).padding.bottom + 16),
                        children: [
                          if (!hasMultipleCategories || _activeCategory == null) ...[
                            // Grouped view
                            for (final cat in categories)
                              if (_activeCategory == null || _activeCategory == cat) ...[
                                if (hasMultipleCategories)
                                  _CategoryHeader(category: cat, count: groups[cat]!.length),
                                for (final v in groups[cat]!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: VendorTile(vendor: v),
                                  ),
                              ],
                            // Pending at the bottom
                            for (final v in pending)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: VendorTile(vendor: v),
                              ),
                          ] else ...[
                            // Filtered single-category view
                            for (final v in groups[_activeCategory] ?? [])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: VendorTile(vendor: v),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  final List<String> categories;
  final String? activeCategory;
  final String Function(String) chipLabel;
  final void Function(String?) onSelect;

  const _CategoryFilterRow({
    required this.categories,
    required this.activeCategory,
    required this.chipLabel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(AppLocalizations.of(context)!.filterAll),
              selected: activeCategory == null,
              onSelected: (_) => onSelect(null),
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary,
            ),
          ),
          for (final cat in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(chipLabel(cat)),
                selected: activeCategory == cat,
                onSelected: (_) => onSelect(activeCategory == cat ? null : cat),
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String category;
  final int count;

  const _CategoryHeader({required this.category, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        AppLocalizations.of(context)!.categoryWithCount(
          category.toUpperCase(),
          count,
        ),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
