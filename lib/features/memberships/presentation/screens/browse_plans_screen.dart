import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/models/membership_plan.dart';
import '../bloc/membership_cubit.dart';
import '../bloc/membership_state.dart';
import '../membership_theme.dart';

/// Customer: browse a vendor's active plans and apply for one.
/// Expects a MembershipCubit (for [linkId]) provided above it.
class BrowsePlansScreen extends StatelessWidget {
  final String vendorName;
  const BrowsePlansScreen({super.key, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (ctx) => Text(
            AppLocalizations.of(ctx)!.vendorPlansTitle(vendorName),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: MembershipTheme.purple,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<MembershipCubit, MembershipState>(
        listenWhen: (_, c) => c is MembershipError,
        listener: (context, state) {
          if (state is MembershipError) {
            AppToast.show(context, state.message, type: ToastType.error);
          }
        },
        builder: (context, state) {
          if (state is! MembershipLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final status = state.status;
          final plans = status.plans;
          final currentPlanId = status.current?.plan.id;
          final pendingPlanId = status.pendingRequest?.requestedPlan?.id;

          if (plans.isEmpty) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.workspace_premium_outlined,
                    size: 56,
                    color: MembershipTheme.purple.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noPlansAvailable,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.vendorNoPlansHint,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            separatorBuilder: (_, i) => const SizedBox(height: 14),
            itemBuilder: (ctx, i) {
              final p = plans[i];
              return _PlanCard(
                plan: p,
                isCurrent: p.id == currentPlanId,
                isPending: p.id == pendingPlanId,
                busy: state.actionInProgress,
                onApply: () => _confirmApply(context, p),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmApply(BuildContext context, MembershipPlan plan) async {
    final cubit = context.read<MembershipCubit>();
    final msgCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        final sl10n = AppLocalizations.of(sheetCtx)!;
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            // viewInsets clears the keyboard; viewPadding clears the gesture
            // bar / 3-button nav when the keyboard is closed.
            bottom:
                MediaQuery.of(sheetCtx).viewInsets.bottom +
                MediaQuery.of(sheetCtx).viewPadding.bottom +
                28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Text(
                sl10n.applyForPlan(plan.name),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sl10n.planPricePerDuration(
                      plan.price.toStringAsFixed(0),
                      plan.durationDays,
                    ) +
                    (plan.advanceRequired > 0
                        ? sl10n.advanceAmountSuffix(
                            plan.advanceRequired.toStringAsFixed(0),
                          )
                        : ''),
                style: TextStyle(
                  color: Theme.of(sheetCtx).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: msgCtrl,
                decoration: InputDecoration(
                  labelText: sl10n.messageToVendorOptional,
                  hintText: sl10n.messageToVendorHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.message_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(sheetCtx, true),
                style: FilledButton.styleFrom(
                  backgroundColor: MembershipTheme.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  sl10n.sendRequestButton,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (ok != true) return;
    await cubit.requestPlan(plan.id, message: msgCtrl.text.trim());
    if (!context.mounted) return;
    final s = cubit.state;
    if (s is MembershipLoaded && s.status.pendingRequest != null) {
      AppToast.show(context, l10n.requestSentToName(vendorName));
      Navigator.pop(context);
    }
  }
}

class _PlanCard extends StatelessWidget {
  final MembershipPlan plan;
  final bool isCurrent;
  final bool isPending;
  final bool busy;
  final VoidCallback onApply;

  const _PlanCard({
    required this.plan,
    required this.isCurrent,
    required this.isPending,
    required this.busy,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final borderColor = isCurrent
        ? MembershipTheme.purple
        : isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isCurrent ? 1.8 : 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: const BoxDecoration(
              gradient: MembershipTheme.headerGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      Builder(
                        builder: (ctx) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(ctx)!.activeLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${plan.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.planDurationSuffix(plan.durationDays),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Benefits + action
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.benefits.isEmpty)
                  Text(
                    AppLocalizations.of(context)!.noAdditionalBenefits,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                  )
                else
                  ...plan.benefits.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              b.label,
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (b.hasQuota)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: MembershipTheme.purple.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '×${b.quota}',
                                style: const TextStyle(
                                  color: MembershipTheme.purple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (plan.advanceRequired > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 14,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.advanceAmountLabel(
                        plan.advanceRequired.toStringAsFixed(0),
                      ),
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, child: _actionButton(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isCurrent) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded, size: 18),
        label: Text(l10n.currentPlanLabel),
        style: OutlinedButton.styleFrom(
          foregroundColor: MembershipTheme.purple,
          side: const BorderSide(color: MembershipTheme.purple),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(44),
        ),
      );
    }
    if (isPending) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.hourglass_top_rounded, size: 18),
        label: Text(l10n.requestPendingLabel),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.warning,
          side: const BorderSide(color: AppColors.warning),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(44),
        ),
      );
    }
    return FilledButton(
      onPressed: busy ? null : onApply,
      style: FilledButton.styleFrom(
        backgroundColor: MembershipTheme.purple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size.fromHeight(44),
      ),
      child: Text(l10n.applyLabel, style: const TextStyle(fontSize: 15)),
    );
  }
}
