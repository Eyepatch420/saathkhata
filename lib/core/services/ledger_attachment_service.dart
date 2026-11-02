import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../network/api_client.dart';

/// Compresses a local image and uploads it as a ledger attachment.
///
/// For the upload-first flow (no entry yet), pass [entryId] as null —
/// the backend stores it under a temp folder and returns the Cloudinary URL,
/// which Flutter then embeds in the POST /entries body.
///
/// For the attach-later flow, pass the known [entryId] — the backend overwrites
/// the entry's attachment_url and emits ledger:entry_updated via socket.
class LedgerAttachmentService {
  final ApiClient _api;

  LedgerAttachmentService(this._api);

  Future<String> uploadAttachment({
    required File imageFile,
    required String linkId,
    String? entryId,
  }) async {
    // Compress before upload — keep high-enough quality for readability
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 88,
      minWidth: 1080,
      minHeight: 1080,
      keepExif: false,
    );

    if (compressedBytes == null) throw Exception('Image compression failed');

    final filename = entryId != null
        ? 'entry_$entryId.jpg'
        : 'temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        compressedBytes,
        filename: filename,
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });

    final String attachmentUrl;
    if (entryId != null) {
      final response = await _api.patch(
        '/links/$linkId/entries/$entryId/attachment',
        data: formData,
      );
      attachmentUrl = ApiClient.extractData(response)['attachmentUrl'] as String;
    } else {
      final response = await _api.post(
        '/links/$linkId/entries/attachment/temp',
        data: formData,
      );
      attachmentUrl = ApiClient.extractData(response)['attachmentUrl'] as String;
    }
    return attachmentUrl;
  }
}
