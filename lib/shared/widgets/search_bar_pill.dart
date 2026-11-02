import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_typography.dart';
import '../../core/router/app_router.dart';
import '../../features/search/presentation/screens/vendor_search_screen.dart';

/// Pill-shaped search bar shown on both the vendor and customer home screens.
///
/// Tapping it triggers a Hero animation that morphs the pill into the full
/// search screen's text field. [viewAs] is passed to [VendorSearchScreen] so
/// it can apply the correct accent colour and label copy.
class SearchBarPill extends StatelessWidget {
  final SearchViewAs viewAs;

  const SearchBarPill({super.key, required this.viewAs});

  Color get _accent =>
      viewAs == SearchViewAs.vendor ? AppColors.primary : AppColors.customerAccent;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final divider = Theme.of(context).dividerColor;

    return Hero(
      tag: 'search_pill_hero_${viewAs.name}',
      // During flight the hero shows this shuttle — a Material container whose
      // border radius tweens from 50 (pill) → 14 (search field).
      flightShuttleBuilder: (flightCtx, animation, direction, fromHero, toHero) {
        return AnimatedBuilder(
          animation: animation,
          builder: (builderCtx, child) {
            final radius = Tween<double>(begin: 50, end: 14)
                .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ))
                .value;
            return Material(
              color: surface,
              borderRadius: BorderRadius.circular(radius),
              elevation: Tween<double>(begin: 0, end: 3)
                  .animate(animation)
                  .value,
              child: const SizedBox(height: 52),
            );
          },
        );
      },
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () => context.push(AppRouter.vendorSearch, extra: viewAs),
          borderRadius: BorderRadius.circular(50),
          splashColor: _accent.withValues(alpha: 0.08),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: divider),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: _accent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!
                        .searchVendorsByCategoryHint,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textHint),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
