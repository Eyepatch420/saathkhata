import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../domain/models/membership_plan.dart';
import '../bloc/plans_cubit.dart';
import '../membership_theme.dart';
import 'create_plan_screen.dart';

class MembershipPlansScreen extends StatelessWidget {
  const MembershipPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlansCubit(getIt())..load(),
      child: const _PlansView(),
    );
  }
}

class _PlansView extends StatefulWidget {
  const _PlansView();

  @override
  State<_PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends State<_PlansView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _fabVisible) {
        _fabVisible = false;
        _fabAnim.reverse();
      } else if (delta < 0 && !_fabVisible) {
        _fabVisible = true;
        _fabAnim.forward();
      }
    }
    return false;
  }

  void _openEditor(BuildContext context, {MembershipPlan? plan}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PlansCubit>(),
          child: CreatePlanScreen(existing: plan),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.membershipPlansTitle),
        backgroundColor: MembershipTheme.purple,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FadeTransition(
        opacity: _fabAnim,
        child: ScaleTransition(
          scale: _fabScale,
          child: FloatingActionButton.extended(
            onPressed: () => _openEditor(context),
            backgroundColor: MembershipTheme.purple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: Text(l10n.newPlanButton),
          ),
        ),
      ),
      body: BlocBuilder<PlansCubit, PlansState>(
        builder: (context, state) {
          if (state is PlansLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlansError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<PlansCubit>().load(),
            );
          }
          if (state is PlansLoaded) {
            if (state.plans.isEmpty) return const _EmptyPlans();
            return NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: state.plans.length,
                separatorBuilder: (_, i) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _PlanCard(
                  plan: state.plans[i],
                  onEdit: () => _openEditor(context, plan: state.plans[i]),
                  onToggle: () => context.read<PlansCubit>().updatePlan(
                        state.plans[i].id,
                        isActive: !state.plans[i].isActive,
                      ),
                  onDelete: () => _confirmDelete(context, state.plans[i]),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, MembershipPlan plan) async {
    final cubit = context.read<PlansCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dl10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dl10n.deletePlanTitle),
          content: Text(dl10n.deletePlanConfirm(plan.name)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(dl10n.cancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(dl10n.deleteButton),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    final success = await cubit.deletePlan(plan.id);
    if (!context.mounted) return;
    if (!success) {
      final s = cubit.state;
      if (s is PlansError) AppToast.show(context, s.message, type: ToastType.error);
    }
  }
}

class _PlanCard extends StatelessWidget {
  final MembershipPlan plan;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _PlanCard({
    required this.plan,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = cs.surface;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.07);
    final secondaryText = cs.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient header — always same purple gradient, looks fine on dark
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: const BoxDecoration(gradient: MembershipTheme.headerGradient),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      const SizedBox(height: 3),
                      Text(
                        l10n.planPricePerDuration(
                        plan.price.toStringAsFixed(0),
                        plan.durationDays,
                      ),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (!plan.isActive)
                  Builder(builder: (ctx) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(AppLocalizations.of(ctx)!.inactiveLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  )),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.benefits.isEmpty)
                  Text(AppLocalizations.of(context)!.noBenefitsAdded,
                      style: TextStyle(color: secondaryText, fontSize: 13))
                else
                  ...plan.benefits.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 16, color: AppColors.success),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(b.label,
                                    style: TextStyle(color: cs.onSurface))),
                            if (b.hasQuota)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: MembershipTheme.purple
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(l10n.benefitQuotaTimes(b.quota ?? 0),
                                    style: const TextStyle(
                                        color: MembershipTheme.purple,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12)),
                              ),
                          ],
                        ),
                      )),
                if (plan.advanceRequired > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          size: 14, color: secondaryText),
                      const SizedBox(width: 6),
                      Text(
                          l10n.advanceAmountLabel(
                        plan.advanceRequired.toStringAsFixed(0),
                      ),
                          style:
                              TextStyle(color: secondaryText, fontSize: 13)),
                    ],
                  ),
                ],
                Divider(
                    height: 22,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06)),
                Row(
                  children: [
                    Icon(Icons.people_alt_rounded,
                        size: 15, color: MembershipTheme.purple),
                    const SizedBox(width: 5),
                    Text(l10n.activeMembersCount(plan.activeMembers),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: MembershipTheme.purple,
                            fontSize: 13)),
                    const Spacer(),
                    TextButton(
                      onPressed: onToggle,
                      style: TextButton.styleFrom(
                        foregroundColor: plan.isActive
                            ? AppColors.error
                            : AppColors.success,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Builder(builder: (ctx) {
                        final l = AppLocalizations.of(ctx)!;
                        return Text(plan.isActive ? l.deactivate : l.activate);
                      }),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: MembershipTheme.purple,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.error,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlans extends StatelessWidget {
  const _EmptyPlans();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final secondaryText = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded,
              size: 64, color: MembershipTheme.purple.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(l10n.noMembershipPlans,
              style: TextStyle(fontSize: 16, color: secondaryText)),
          const SizedBox(height: 6),
          Text(l10n.tapNewPlanHint,
              style: TextStyle(
                  fontSize: 13,
                  color: secondaryText.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
