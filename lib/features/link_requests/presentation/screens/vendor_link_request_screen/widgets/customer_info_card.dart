import 'package:flutter/material.dart';
import '../../../../../../features/link_requests/domain/models/link_request_model.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_typography.dart';
import '../../../../../../../core/utils/app_logger.dart';
import '../../../../../../../l10n/app_localizations.dart';

class CustomerInfoCard extends StatelessWidget {
  final LinkRequestUserBrief customer;
  final String? message;

  const CustomerInfoCard({
    super.key,
    required this.customer,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CustomerAvatar(customer: customer),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: AppTypography.h3),
                    const SizedBox(height: 4),
                    if (customer.email != null) ...[
                      Text(
                        customer.email!,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                    if (customer.mobile != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        customer.mobile!,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.messageLabel,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textHint),
                  ),
                  const SizedBox(height: 4),
                  Text(message!, style: AppTypography.bodyMedium.copyWith(height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  final LinkRequestUserBrief customer;
  const _CustomerAvatar({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.customerAccent.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: customer.profilePhotoUrl != null
          ? Image.network(
              customer.profilePhotoUrl!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) {
                AppLogger.w('CustomerInfoCard',
                    'Profile photo failed for ${customer.id} — $error');
                return _Initial(initial: customer.avatarInitial);
              },
            )
          : _Initial(initial: customer.avatarInitial),
    );
  }
}

class _Initial extends StatelessWidget {
  final String initial;
  const _Initial({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Text(
      initial,
      style: const TextStyle(
        color: AppColors.customerAccent,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}
