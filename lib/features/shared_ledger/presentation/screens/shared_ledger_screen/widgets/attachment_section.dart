import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'full_screen_photo_viewer.dart';

/// Shows a thumbnail when [attachmentUrl] is set; tapping opens [FullScreenPhotoViewer].
/// When [isLocked] is true a "Proof Locked" badge overlays the thumbnail.
class LedgerAttachmentSection extends StatelessWidget {
  final String? attachmentUrl;
  final bool isLocked;

  /// Must be unique per entry. Use distinct prefixes for card vs detail sheet
  /// (e.g. `entry_attachment_id` vs `detail_attachment_id`) to avoid
  /// Hero conflicts when both are in the tree simultaneously.
  final String heroTag;

  const LedgerAttachmentSection({
    super.key,
    required this.attachmentUrl,
    required this.isLocked,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (attachmentUrl == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Hero(
              tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: attachmentUrl!,
                width: 150,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(
                  width: 150,
                  height: 100,
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  width: 150,
                  height: 100,
                  color: AppColors.textHint.withValues(alpha: 0.1),
                  child: const Icon(Icons.broken_image_rounded,
                      color: AppColors.textHint),
                ),
              ),
            ),
            if (isLocked)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: Colors.white, size: 10),
                      const SizedBox(width: 3),
                      Text(
                        AppLocalizations.of(context)!.proofLocked,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (ctx, anim, secondAnim) => FullScreenPhotoViewer(
          imageUrl: attachmentUrl!,
          heroTag: heroTag,
          isLocked: isLocked,
        ),
      ),
    );
  }
}
