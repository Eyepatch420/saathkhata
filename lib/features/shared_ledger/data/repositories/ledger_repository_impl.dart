import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/ledger_attachment_service.dart';
import '../../domain/models/ledger_filter.dart';
import '../../domain/repositories/ledger_repository.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/models/ledger_balance.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  final ApiClient _api;

  // Cached from the most recent getEntries / addEntry call.
  // Used by confirmEntry / disputeEntry which need :linkId in the URL
  // but the BLoC only passes entryId.
  String? _currentLinkId;

  LedgerRepositoryImpl(this._api);

  @override
  Future<LedgerPageResult> getEntries(
    String linkId, {
    int page = 1,
    int limit = 50,
    LedgerFilter? filter,
  }) async {
    _currentLinkId = linkId;
    try {
      final params = <String, dynamic>{'page': page, 'limit': limit};
      if (filter != null) params.addAll(filter.toQueryParams());
      final response = await _api.get(
        ApiEndpoints.linkEntries(linkId),
        queryParameters: params,
      );
      final data = ApiClient.extractData(response);
      final list = (data['entries'] as List?) ?? [];
      final entries = list
          .map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      final total = (data['total'] as num?)?.toInt() ?? entries.length;
      return LedgerPageResult(entries: entries, total: total);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LedgerEntry> addEntry(LedgerEntry entry) async {
    _currentLinkId = entry.linkId;
    try {
      final body = <String, dynamic>{
        'amount': entry.amount,
        'type': entry.type.toJson(),
        // Must be UTC so the ISO string carries a 'Z' suffix — the backend's
        // zod `.datetime()` validator rejects local strings with no timezone.
        'date': entry.date.toUtc().toIso8601String(),
      };
      if (entry.description != null) body['description'] = entry.description;
      if (entry.quantity != null) body['quantity'] = entry.quantity;
      if (entry.unit != null) body['unit'] = entry.unit;
      if (entry.attachmentUrl != null) body['attachmentUrl'] = entry.attachmentUrl;
      if (entry.parentEntryId != null) body['parentEntryId'] = entry.parentEntryId;
      if (entry.isParent) body['isParent'] = true;

      final response = await _api.post(
        ApiEndpoints.linkEntries(entry.linkId),
        data: body,
      );
      return LedgerEntry.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LedgerEntry> confirmEntry(String entryId) async {
    final linkId = _currentLinkId;
    if (linkId == null) throw Exception('No active link — call getEntries first');
    try {
      final response = await _api.patch(
        ApiEndpoints.confirmEntry(linkId, entryId),
      );
      return LedgerEntry.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LedgerEntry> disputeEntry(String entryId, String reason) async {
    final linkId = _currentLinkId;
    if (linkId == null) throw Exception('No active link — call getEntries first');
    try {
      final response = await _api.patch(
        ApiEndpoints.disputeEntry(linkId, entryId),
        data: {'reason': reason},
      );
      return LedgerEntry.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile) async {
    try {
      await getIt<LedgerAttachmentService>().uploadAttachment(
        imageFile: imageFile,
        linkId: linkId,
        entryId: entryId,
      );
      // The socket broadcasts ledger:entry_updated after the backend writes.
      // Return the current cached entry — the bloc replaces it on socket arrival.
      final result = await getEntries(linkId);
      return result.entries.firstWhere(
        (e) => e.id == entryId,
        orElse: () => throw Exception('Entry not found after attachment upload'),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LedgerBalance> getBalance(String linkId) async {
    _currentLinkId = linkId;
    try {
      final response = await _api.get(ApiEndpoints.linkBalance(linkId));
      return LedgerBalance.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
