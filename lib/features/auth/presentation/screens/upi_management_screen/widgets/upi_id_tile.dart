import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_typography.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Local UI state entry — independent of the server model.
class UpiEntry {
  final String? serverId;
  final String upiId;
  final bool isPrimary;

  const UpiEntry({this.serverId, required this.upiId, required this.isPrimary});

  UpiEntry copyWith({bool? isPrimary}) => UpiEntry(
    serverId: serverId,
    upiId: upiId,
    isPrimary: isPrimary ?? this.isPrimary,
  );
}

class UpiIdTile extends StatelessWidget {
  final UpiEntry entry;
  final VoidCallback onSetPrimary;
  final VoidCallback? onDelete;

  const UpiIdTile({
    super.key,
    required this.entry,
    required this.onSetPrimary,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: entry.isPrimary
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: entry.isPrimary ? null : onSetPrimary,
          child: Tooltip(
            message: entry.isPrimary
                ? l10n.primaryUpiIdTooltip
                : l10n.setAsPrimaryTooltip,
            child: Icon(
              entry.isPrimary ? Icons.star_rounded : Icons.star_outline_rounded,
              color: entry.isPrimary ? Colors.amber : AppColors.textHint,
              size: 26,
            ),
          ),
        ),
        title: Text(
          entry.upiId,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: entry.isPrimary ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: entry.isPrimary
            ? Text(
                l10n.primaryLabel,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              )
            : null,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                onPressed: onDelete,
                tooltip: l10n.removeButtonLabel,
              )
            : null,
      ),
    );
  }
}
