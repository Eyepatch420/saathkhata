import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../domain/models/link_request_model.dart';
import '../bloc/link_request_cubit.dart';
import '../bloc/link_request_state.dart';

/// Customer approval screen — opened by tapping a vendor_link_request_received notification.
///
/// A vendor has sent a request to add this user as a customer. The customer
/// can accept (creates the link) or decline.
class CustomerLinkRequestScreen extends StatelessWidget {
  final String requestId;

  const CustomerLinkRequestScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LinkRequestCubit(getIt())..loadRequest(requestId),
      child: _CustomerLinkRequestView(requestId: requestId),
    );
  }
}

class _CustomerLinkRequestView extends StatelessWidget {
  final String requestId;
  const _CustomerLinkRequestView({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkRequestCubit, LinkRequestState>(
      listener: (ctx, state) {
        if (state is LinkRequestResponded) {
          final accepted = state.request.status == LinkRequestStatus.accepted;
          final vendorName = state.request.vendor.displayName;
          final l10n = AppLocalizations.of(ctx)!;
          AppToast.show(
            ctx,
            accepted
                ? l10n.connectedVendorLinked(vendorName)
                : l10n.requestDeclinedFrom(vendorName),
            type: accepted ? ToastType.success : ToastType.info,
          );
          // Pop twice: once to close this screen, once more to land on dashboard.
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
              LinkRequestLoading() => const Center(child: CircularProgressIndicator()),
              LinkRequestError(message: final m) => _ErrorView(
                  message: m,
                  onRetry: () => ctx.read<LinkRequestCubit>().loadRequest(requestId),
                ),
              LinkRequestLoaded(request: final req) => _RequestBody(
                  request: req,
                  onAccept: () => ctx.read<LinkRequestCubit>().accept(req.id),
                  onDecline: () => ctx.read<LinkRequestCubit>().decline(req.id),
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }
}

// ── Request body ──────────────────────────────────────────────────────────────

class _RequestBody extends StatelessWidget {
  final LinkRequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestBody({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final vendor = request.vendor;
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
              color: AppColors.customerAccent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.customerAccent.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.customerAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: AppColors.customerAccent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.vendorWantsToConnectAsCustomer, style: AppTypography.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context)!.vendorWantsToConnectDesc,
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

          // Vendor details card
          _VendorInfoCard(vendor: vendor, message: request.message),
          const SizedBox(height: 12),

          // Timestamp
          Center(
            child: Text(
              AppLocalizations.of(context)!.requestedTimeAgo(_timeAgo(context, request.createdAt)),
              style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
            ),
          ),

          const Spacer(),

          // Accept / Decline buttons
          BlocBuilder<LinkRequestCubit, LinkRequestState>(
            builder: (ctx, state) {
              final isLoading = state is LinkRequestLoading;
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_rounded,
                              color: Colors.white, size: 20),
                      label: Text(AppLocalizations.of(context)!.acceptRequest,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 20),
                      label: Text(AppLocalizations.of(context)!.declineRequest,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              );
            },
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

// ── Vendor info card ──────────────────────────────────────────────────────────

class _VendorInfoCard extends StatelessWidget {
  final LinkRequestUserBrief vendor;
  final String? message;

  const _VendorInfoCard({required this.vendor, this.message});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final displayName = vendor.displayName;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.customerAccent.withValues(alpha: 0.15),
                child: Text(
                  vendor.avatarInitial,
                  style: const TextStyle(
                    color: AppColors.customerAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: AppTypography.h3),
                    if (vendor.businessName != null &&
                        vendor.businessName != vendor.name)
                      Text(
                        AppLocalizations.of(context)!.byName(vendor.name),
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    if (vendor.businessCategory != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.customerAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vendor.businessCategory!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.customerAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.messageLabel, style: AppTypography.bodySmall.copyWith(color: AppColors.textHint)),
            const SizedBox(height: 4),
            Text(message!, style: AppTypography.bodyMedium),
          ],
        ],
      ),
    );
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
