import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/link_model.dart';
import '../../../../shared/widgets/app_toast.dart';

class VendorTile extends StatelessWidget {
  final VendorLinkItem vendor;
  const VendorTile({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return vendor.isPending
        ? _PendingVendorTile(vendor: vendor)
        : _ActiveVendorTile(vendor: vendor);
  }
}

// ─── Active link tile ─────────────────────────────────────────────────────────

class _ActiveVendorTile extends StatelessWidget {
  final VendorLinkItem vendor;
  const _ActiveVendorTile({required this.vendor});

  @override
  Widget build(BuildContext context) {
    final displayName = vendor.displayName;
    final subName = vendor.subName;
    final surface = Theme.of(context).colorScheme.surface;
    return InkWell(
      onTap: () => context.push(
        AppRouter.sharedLedger,
        extra: {'linkId': vendor.linkId, 'name': displayName, 'isVendorView': false},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(displayName[0].toUpperCase(),
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName,
                      style: AppTypography.labelLarge,
                      overflow: TextOverflow.ellipsis),
                  if (subName != null)
                    Text(subName,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis)
                  else if (vendor.vendor.businessCategory != null)
                    Text(vendor.vendor.businessCategory!,
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${vendor.balance.toStringAsFixed(0)}',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
                Text(AppLocalizations.of(context)!.outstanding,
                    style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                const SizedBox(height: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push(
                    AppRouter.bookAppointment,
                    extra: {'vendorId': vendor.vendor.id, 'vendorName': displayName},
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.bookButton,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push(AppRouter.placeOrder, extra: vendor),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_outlined,
                            size: 11, color: Color(0xFFFF6B35)),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.orderButtonLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFFFF6B35),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ─── Pending request tile ─────────────────────────────────────────────────────

class _PendingVendorTile extends StatelessWidget {
  final VendorLinkItem vendor;
  const _PendingVendorTile({required this.vendor});

  @override
  Widget build(BuildContext context) {
    final displayName = vendor.displayName;
    final subName = vendor.subName;
    final surface = Theme.of(context).colorScheme.surface;

    return InkWell(
      onTap: () => AppToast.show(
        context,
        AppLocalizations.of(context)!.waitingForVendorAcceptance(displayName),
        type: ToastType.info,
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.customerAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.customerAccent.withValues(alpha: 0.12),
              child: Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                    color: AppColors.customerAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName,
                      style: AppTypography.labelLarge,
                      overflow: TextOverflow.ellipsis),
                  if (subName != null)
                    Text(subName,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis)
                  else if (vendor.vendor.businessCategory != null)
                    Text(vendor.vendor.businessCategory!,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.customerAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.customerAccent.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 11, color: AppColors.customerAccent),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.statusPending,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.customerAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.hourglass_empty_rounded,
                color: AppColors.customerAccent.withValues(alpha: 0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
