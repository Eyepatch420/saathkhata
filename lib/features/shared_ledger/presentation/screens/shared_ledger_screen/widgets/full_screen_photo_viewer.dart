import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/constants/app_typography.dart';

class FullScreenPhotoViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final bool isLocked;

  const FullScreenPhotoViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isLocked
            ? Row(
                children: [
                  const Icon(Icons.lock_rounded,
                      color: AppColors.warning, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.proofLocked,
                    style:
                        AppTypography.labelLarge.copyWith(color: Colors.white),
                  ),
                ],
              )
            : Text(
                AppLocalizations.of(context)!.paymentProofTitle,
                style: AppTypography.labelLarge.copyWith(color: Colors.white),
              ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Hero(
            tag: heroTag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (ctx, url) => const CircularProgressIndicator(
                color: Colors.white,
              ),
              errorWidget: (ctx, url, err) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image_rounded,
                      color: Colors.white54, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.couldNotLoadImage,
                    style: AppTypography.bodySmall
                        .copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
