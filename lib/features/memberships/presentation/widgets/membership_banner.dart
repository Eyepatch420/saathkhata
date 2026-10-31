import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/membership_plan.dart';
import '../bloc/membership_cubit.dart';
import '../bloc/membership_state.dart';
import '../membership_theme.dart';

class MembershipBanner extends StatelessWidget {
  final String customerName;
  final bool isVendorView;
  final bool isStaffView;

  const MembershipBanner({
    super.key,
    required this.customerName,
    required this.isVendorView,
    this.isStaffView = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembershipCubit, MembershipState>(
      listenWhen: (prev, curr) => curr is MembershipError,
      listener: (context, state) {
        if (state is MembershipError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        if (state is! MembershipLoaded) return const SizedBox.shrink();
        final status = state.status;
        final busy = state.actionInProgress;
        final cubit = context.read<MembershipCubit>();
        final current = status.current;
        final cs = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final borderColor = isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.07);
        final secondaryColor = cs.onSurfaceVariant;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium_rounded,
                      color: current != null
                          ? MembershipTheme.purple
                          : secondaryColor.withValues(alpha: 0.5),
                      size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.membershipLabel,
                            style: AppTypography.bodySmall
                                .copyWith(color: secondaryColor)),
                        Text(
                          current?.plan.name ?? AppLocalizations.of(context)!.noMembership,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: current != null
                                ? MembershipTheme.purple
                                : secondaryColor,
                          ),
                        ),
                        if (current != null)
                          Text(
                              AppLocalizations.of(context)!.daysLeftLabel(
                                  current.daysLeft),
                              style: AppTypography.bodySmall
                                  .copyWith(color: secondaryColor)),
                      ],
                    ),
                  ),
                  if (busy)
                    const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    TextButton.icon(
                      onPressed: () => _openEnrollPicker(
                          context, cubit, status.plans, current?.plan.id),
                      icon: Icon(
                          current == null
                              ? Icons.add_rounded
                              : Icons.swap_horiz_rounded,
                          size: 16),
                      label: Text(current == null ? AppLocalizations.of(context)!.enrollLabel : AppLocalizations.of(context)!.changeLabel),
                      style: TextButton.styleFrom(
                          foregroundColor: MembershipTheme.purple),
                    ),
                ],
              ),

              // Quota benefit usage rows (vendor only).
              if (current != null &&
                  current.benefitUsage.any((b) => b.hasQuota)) ...[
                Divider(
                    height: 18,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06)),
                ...current.benefitUsage.where((b) => b.hasQuota).map((b) {
                  final done = b.used >= (b.quota ?? 0);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(b.label,
                                style: TextStyle(color: cs.onSurface))),
                        // Vendor-only correction: decrement a mistaken redemption.
                        if (isVendorView) ...[
                          IconButton(
                            onPressed: (busy || b.used <= 0)
                                ? null
                                : () => cubit.decrementBenefit(
                                    current.id, b.benefitId),
                            icon: const Icon(Icons.remove_circle_outline,
                                size: 18),
                            color: AppColors.error,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 28, minHeight: 28),
                            tooltip: AppLocalizations.of(context)!.decreaseLabel,
                          ),
                          const SizedBox(width: 2),
                        ],
                        Text(
                            AppLocalizations.of(context)!.usedOfQuota(
                                b.used, b.quota ?? 0),
                            style: TextStyle(
                                color: done
                                    ? AppColors.error
                                    : AppColors.success,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: (busy || done)
                              ? null
                              : () =>
                                  cubit.useBenefit(current.id, b.benefitId),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 32),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            foregroundColor: MembershipTheme.purple,
                            side: const BorderSide(
                                color: MembershipTheme.purple),
                          ),
                          child: Text(done ? AppLocalizations.of(context)!.usedLabel : AppLocalizations.of(context)!.useLabel,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }),
              ],

              // Pending request card — approve / decline.
              if (status.pendingRequest != null) ...[
                const SizedBox(height: 12),
                _PendingRequestCard(
                  planName:
                      status.pendingRequest!.requestedPlan?.name ??
                          AppLocalizations.of(context)!.aPlanLabel,
                  message: status.pendingRequest!.message,
                  customerName: customerName,
                  busy: busy,
                  onApprove: () => cubit.approve(status.pendingRequest!.id),
                  onDecline: () => cubit.decline(status.pendingRequest!.id),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _openEnrollPicker(
    BuildContext context,
    MembershipCubit cubit,
    List<MembershipPlan> plans,
    String? currentPlanId,
  ) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        final cs = Theme.of(sheetCtx).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (bctx) {
                final sl10n = AppLocalizations.of(bctx)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        sl10n.enrollCustomer(customerName.isEmpty
                            ? sl10n.customer
                            : customerName),
                        style: AppTypography.h3.copyWith(color: cs.onSurface)),
                    const SizedBox(height: 4),
                    Text(sl10n.choosePlanHint,
                        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
                  ],
                );
              }),
              const SizedBox(height: 16),
              if (plans.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Builder(builder: (bctx) => Text(
                      AppLocalizations.of(bctx)!.noActivePlansHint,
                      style: TextStyle(color: cs.onSurfaceVariant))),
                )
              else
                ...plans.map((p) {
                  final isCurrent = p.id == currentPlanId;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          MembershipTheme.purple.withValues(alpha: 0.12),
                      child: const Icon(Icons.workspace_premium_rounded,
                          color: MembershipTheme.purple),
                    ),
                    title: Text(p.name,
                        style: TextStyle(color: cs.onSurface)),
                    subtitle: Text(
                        AppLocalizations.of(context)!
                            .planPriceAndDuration(
                                p.price.toStringAsFixed(0), p.durationDays),
                        style: TextStyle(color: cs.onSurfaceVariant)),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle,
                            color: AppColors.success)
                        : null,
                    onTap: isCurrent
                        ? null
                        : () {
                            Navigator.pop(sheetCtx);
                            cubit.enroll(p.id);
                          },
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final String planName;
  final String? message;
  final String customerName;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const _PendingRequestCard({
    required this.planName,
    required this.message,
    required this.customerName,
    required this.busy,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MembershipTheme.purple.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: MembershipTheme.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.upgrade_rounded,
                  color: MembershipTheme.purple, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Builder(builder: (ctx) => Text(
                    AppLocalizations.of(ctx)!.customerRequestedPlan(customerName, planName),
                    style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14))),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('"$message"',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
          ],
          const SizedBox(height: 10),
          Builder(builder: (ctx) {
            final l10n = AppLocalizations.of(ctx)!;
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy ? null : onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: Text(l10n.decline),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: busy ? null : onApprove,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.approve),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
