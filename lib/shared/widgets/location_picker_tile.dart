import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/location_model.dart';

/// Tappable tile that shows a picked location or prompts the user to pick one.
/// Used in both ProfileSetupScreen and EditProfileScreen.
class LocationPickerTile extends StatelessWidget {
  final LocationData? location;
  final bool enabled;
  final VoidCallback onTap;
  final String? label;

  const LocationPickerTile({
    super.key,
    required this.location,
    required this.onTap,
    this.enabled = true,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocation = location != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? AppLocalizations.of(context)!.businessAddress,
          style: AppTypography.labelLarge,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasLocation
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasLocation
                      ? Icons.location_on_rounded
                      : Icons.add_location_alt_outlined,
                  color: hasLocation ? AppColors.primary : AppColors.textHint,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: hasLocation
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location!.shortAddress,
                              style: AppTypography.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)!.latLngValue(
                                location!.lat.toStringAsFixed(5),
                                location!.lng.toStringAsFixed(5),
                              ),
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.textHint),
                            ),
                          ],
                        )
                      : Text(
                          AppLocalizations.of(context)!.tapToPickOnMap,
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.textHint),
                        ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
