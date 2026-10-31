import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../vendor/presentation/bloc/vendor_bloc.dart';
import '../../../vendor/presentation/bloc/vendor_event.dart';
import '../../domain/models/link_request_model.dart';
import '../bloc/link_request_cubit.dart';
import '../bloc/link_request_state.dart';
import 'vendor_link_request_screen/widgets/action_buttons.dart';
import 'vendor_link_request_screen/widgets/customer_info_card.dart';

/// Vendor approval screen — opened by tapping a link_request_received notification.
///
/// Receives [requestId] from GoRouter extras.
class VendorLinkRequestScreen extends StatelessWidget {
  final String requestId;

  const VendorLinkRequestScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LinkRequestCubit(getIt())..loadRequest(requestId),
      child: _VendorLinkRequestView(requestId: requestId),
    );
  }
}

class _VendorLinkRequestView extends StatelessWidget {
  final String requestId;
  const _VendorLinkRequestView({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkRequestCubit, LinkRequestState>(
      listener: (ctx, state) {
        if (state is LinkRequestResponded) {
          final accepted = state.request.status == LinkRequestStatus.accepted;
          final customerName = state.request.customer.name;
          final l10n = AppLocalizations.of(ctx)!;
          AppToast.show(
            ctx,
            accepted
                ? l10n.connectedCustomerLinked(customerName)
                : l10n.requestDeclinedFrom(customerName),
            type: accepted ? ToastType.success : ToastType.info,
          );
          // Refresh vendor dashboard so the new customer/vendor appears immediately.
          getIt<VendorBloc>().add(LoadVendorDashboard());
          final nav = Navigator.of(ctx);
          nav.pop();
          if (nav.canPop()) nav.pop();
        } else if (state is LinkRequestError) {
          AppToast.show(ctx, state.message, type: ToastType.error);
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(ctx)!.connectionRequest),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: switch (state) {
              LinkRequestLoading() => const Center(
                  child: CircularProgressIndicator()),
              LinkRequestError(message: final m) => _ErrorView(
                  message: m,
                  onRetry: () =>
                      ctx.read<LinkRequestCubit>().loadRequest(requestId),
                ),
              LinkRequestLoaded(request: final req) => _RequestBody(
                  request: req,
                  isLoading: false,
                  onAccept: () =>
                      ctx.read<LinkRequestCubit>().accept(req.id),
                  onDecline: () =>
                      ctx.read<LinkRequestCubit>().decline(req.id),
                ),
              // While accept/decline is in-flight, keep body visible
              // but buttons show loading state — handled via isLoading flag
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }
}

// ── Request body ─────────────────────────────────────────────────────────────

class _RequestBody extends StatelessWidget {
  final LinkRequestModel request;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestBody({
    required this.request,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.someoneWantsToConnect,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context)!.someoneWantsToConnectDesc,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customer details card
          CustomerInfoCard(
            customer: request.customer,
            message: request.message,
          ),
          const SizedBox(height: 12),

          // Timestamp
          Center(
            child: Text(
              AppLocalizations.of(context)!.requestedTimeAgo(_timeAgo(context, request.createdAt)),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textHint),
            ),
          ),

          const Spacer(),

          // Accept / Decline buttons
          BlocBuilder<LinkRequestCubit, LinkRequestState>(
            builder: (ctx, state) => RequestActionButtons(
              isLoading: state is LinkRequestLoading,
              onAccept: onAccept,
              onDecline: onDecline,
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final l10n = AppLocalizations.of(context)!;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    return l10n.daysAgo(diff.inDays);
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}
