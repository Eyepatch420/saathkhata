import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/membership_cubit.dart';
import '../bloc/membership_state.dart';
import '../membership_theme.dart';
import '../screens/browse_plans_screen.dart';

/// Compact membership indicator for the shared-ledger AppBar, all three roles.
/// - Customer: tap opens the Browse Plans screen (apply / view current).
/// - Vendor/staff: tap shows a read-only info dialog (vendor manages via banner).
class MembershipAppBarChip extends StatelessWidget {
  /// 'vendor' | 'customer' | 'staff' — controls tap behaviour.
  final String role;
  final String vendorName;

  const MembershipAppBarChip({
    super.key,
    required this.role,
    required this.vendorName,
  });

  bool get _isCustomer => role == 'customer';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembershipCubit, MembershipState>(
      builder: (context, state) {
        if (state is! MembershipLoaded) return const SizedBox.shrink();
        final current = state.status.current;
        final hasPlan = current != null;
        final color = hasPlan
            ? MembershipTheme.purple
            : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

        return IconButton(
          tooltip: hasPlan ? current.plan.name : AppLocalizations.of(context)!.membershipLabel,
          visualDensity: VisualDensity.compact,
          onPressed: () => _onTap(context, state),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.workspace_premium_rounded, color: color),
              if (hasPlan)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: MembershipTheme.purple,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onTap(BuildContext context, MembershipLoaded state) {
    if (_isCustomer) {
      // Customer: go to the browse/apply screen (share the same cubit).
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<MembershipCubit>(),
            child: BrowsePlansScreen(vendorName: vendorName),
          ),
        ),
      );
      return;
    }
    _showInfo(context, state);
  }

  void _showInfo(BuildContext context, MembershipLoaded state) {
    final current = state.status.current;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.workspace_premium_rounded, color: MembershipTheme.purple),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(ctx)!.membershipLabel),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (ctx) {
              final cs = Theme.of(ctx).colorScheme;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(current?.plan.name ?? AppLocalizations.of(ctx)!.noMembership,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: current != null
                              ? MembershipTheme.purple
                              : cs.onSurfaceVariant)),
                  if (current != null) ...[
                    const SizedBox(height: 6),
                    Text(
                        AppLocalizations.of(ctx)!.planPriceAndDaysLeft(
                            current.plan.price.toStringAsFixed(0),
                            current.daysLeft),
                        style: TextStyle(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 10),
                    ...current.benefitUsage.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  size: 14, color: AppColors.success),
                              const SizedBox(width: 6),
                              Expanded(
                                  child: Text(b.label,
                                      style: TextStyle(color: cs.onSurface))),
                              if (b.hasQuota)
                                Text(
                                    AppLocalizations.of(ctx)!
                                        .usedOfQuota(b.used, b.quota ?? 0),
                                    style: TextStyle(
                                        color: cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                  ],
                ],
              );
            }),
            if (state.status.pendingRequest != null) ...[
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(ctx)!.pendingPlanLabel(state.status.pendingRequest!.requestedPlan?.name ?? ''),
                style: const TextStyle(
                    color: AppColors.warning, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx)!.closeLabel)),
        ],
      ),
    );
  }
}
