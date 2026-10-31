import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../vendor/domain/repositories/vendor_repository.dart';
import '../../domain/models/members_dashboard.dart';
import '../bloc/members_dashboard_cubit.dart';
import '../membership_theme.dart';

class MembersDashboardScreen extends StatelessWidget {
  const MembersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MembersDashboardCubit(getIt())..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();
  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  String _planFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.membersTitle),
        backgroundColor: MembershipTheme.purple,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MembersDashboardCubit, MembersDashboardState>(
        builder: (context, state) {
          if (state is MembersDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MembersDashboardError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<MembersDashboardCubit>().load(),
            );
          }
          if (state is MembersDashboardLoaded) {
            return _content(context, state.data);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _content(BuildContext context, MembersDashboard data) {
    final members = _planFilter == 'all'
        ? data.members
        : data.members.where((m) => m.planId == _planFilter).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => context.read<MembersDashboardCubit>().load(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _statsRow(data),
          const SizedBox(height: 16),
          _planFilterChips(data),
          const SizedBox(height: 8),
          if (members.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 48,
                      color: MembershipTheme.purple.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.noMembersYet,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...members.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MemberCard(
                  member: m,
                  isDark: isDark,
                  onTap: () => _openMemberDetail(context, m),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statsRow(MembersDashboard data) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _stat(
          '${data.activeCount}',
          l10n.activeStatLabel,
          MembershipTheme.purple,
        ),
        const SizedBox(width: 10),
        _stat('₹${data.mrr}', l10n.mrrStatLabel, AppColors.success),
        const SizedBox(width: 10),
        _stat(
          '${data.expiringSoon}',
          l10n.expiringStatLabel,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.22)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMemberDetail(BuildContext context, MemberRow member) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final customer = await getIt<VendorRepository>().getCustomerByLinkId(
        member.linkId,
      );
      if (!context.mounted) return;
      Navigator.of(context).pop(); // close loading dialog
      context.push(AppRouter.customerDetail, extra: customer);
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      AppToast.show(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        type: ToastType.error,
      );
    }
  }

  Widget _planFilterChips(MembersDashboard data) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _filterChip(AppLocalizations.of(context)!.allPlansFilter, 'all'),
          ...data.plans.map((p) => _filterChip(p.name, p.id)),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _planFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: MembershipTheme.purple.withValues(alpha: 0.15),
        checkmarkColor: MembershipTheme.purple,
        labelStyle: TextStyle(
          color: selected
              ? MembershipTheme.purple
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
        onSelected: (_) => setState(() => _planFilter = value),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final MemberRow member;
  final bool isDark;
  final VoidCallback onTap;
  const _MemberCard({
    required this.member,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final expSoon = member.daysLeft <= 7;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    Color usageColor;
    if (member.hasQuota) {
      if (member.totalUsed >= member.totalQuota) {
        usageColor = AppColors.error;
      } else if (member.totalUsed > 0) {
        usageColor = AppColors.warning;
      } else {
        usageColor = AppColors.success;
      }
    } else {
      usageColor = AppColors.success;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: MembershipTheme.purple.withValues(alpha: 0.15),
                backgroundImage: member.customerPhotoUrl != null
                    ? NetworkImage(member.customerPhotoUrl!)
                    : null,
                child: member.customerPhotoUrl == null
                    ? Text(
                        member.customerName.isNotEmpty
                            ? member.customerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: MembershipTheme.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.customerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.planWithExpiry(
                        member.planName,
                        _fmt(member.expiresAt),
                      ),
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (member.hasQuota)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: usageColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.usedOfQuota(
                          member.totalUsed,
                          member.totalQuota,
                        ),
                        style: TextStyle(
                          color: usageColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    expSoon
                        ? l10n.daysLeftWithWarning(member.daysLeft)
                        : l10n.daysLeftFull(member.daysLeft),
                    style: TextStyle(
                      color: expSoon ? AppColors.warning : cs.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: expSoon ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime d) => DateFormat('d MMM').format(d);
}
