import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_typography.dart';
import '../../../../../../../l10n/app_localizations.dart';

class RequestActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RequestActionButtons({
    super.key,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Decline — outlined, red
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onDecline,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: AppColors.error,
              side: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.close_rounded, size: 20),
            label: Text(AppLocalizations.of(context)!.declineRequest,
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.error)),
          ),
        ),
        const SizedBox(width: 12),
        // Accept — filled, green
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
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
            label: Text(
              isLoading ? AppLocalizations.of(context)!.processing : AppLocalizations.of(context)!.acceptRequest,
              style: AppTypography.labelLarge
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
