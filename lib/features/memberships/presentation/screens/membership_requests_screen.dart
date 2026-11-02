import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../domain/models/membership_request.dart';
import '../bloc/membership_requests_cubit.dart';
import '../membership_theme.dart';

class MembershipRequestsScreen extends StatelessWidget {
  const MembershipRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MembershipRequestsCubit(getIt())..load(),
      child: const _MembershipRequestsView(),
    );
  }
}

class _MembershipRequestsView extends StatelessWidget {
  const _MembershipRequestsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.membershipRequestsTitle)),
      body: SafeArea(
        child: BlocConsumer<MembershipRequestsCubit, MembershipRequestsState>(
          listenWhen: (_, curr) => curr is MembershipRequestsError,
          listener: (context, state) {
            if (state is MembershipRequestsError) {
              AppToast.show(context, state.message, type: ToastType.error);
            }
          },
          builder: (context, state) {
            if (state is MembershipRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MembershipRequestsError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () =>
                    context.read<MembershipRequestsCubit>().load(),
              );
            }
            if (state is MembershipRequestsLoaded) {
              return _RequestList(state: state);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final MembershipRequestsLoaded state;
  const _RequestList({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MembershipRequestsCubit>();

    if (state.requests.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      final cs = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64,
                color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(l10n.noPendingRequests,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              l10n.customersCanApplyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 13),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.requests.length,
        separatorBuilder: (_, i) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final req = state.requests[i];
          final busy = state.busyIds.contains(req.id);
          return _RequestCard(
            request: req,
            busy: busy,
            onApprove: () => cubit.approve(req.id),
            onDecline: () => cubit.decline(req.id),
          );
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final MembershipRequest request;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.request,
    required this.busy,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final plan = request.requestedPlan;
    const planColor = MembershipTheme.purple;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : planColor.withValues(alpha: 0.25);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: planColor.withValues(alpha: 0.12),
                child: Text(
                  request.customer.name[0].toUpperCase(),
                  style: const TextStyle(
                      color: planColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.customer.name,
                        style: AppTypography.labelLarge
                            .copyWith(color: cs.onSurface)),
                    const SizedBox(height: 2),
                    Text(_formatDate(context, request.createdAt),
                        style: TextStyle(
                            color: cs.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              _PlanBadge(
      name: plan?.name ?? AppLocalizations.of(context)!.planFallbackLabel,
      color: planColor,
    ),
            ],
          ),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded,
                      size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      request.message!,
                      style: TextStyle(
                          color: cs.onSurfaceVariant, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          if (busy)
            const Center(child: CircularProgressIndicator())
          else
            Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx)!;
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: Text(l10n.decline),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onApprove,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
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

  String _formatDate(BuildContext context, DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final l10n = AppLocalizations.of(context)!;
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return l10n.minutesAgo(diff.inMinutes);
      return l10n.hoursAgo(diff.inHours);
    }
    if (diff.inDays == 1) return l10n.yesterday;
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _PlanBadge extends StatelessWidget {
  final String name;
  final Color color;

  const _PlanBadge({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: const BoxConstraints(maxWidth: 120),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
