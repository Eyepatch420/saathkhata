import '../models/link_request_model.dart';

abstract class LinkRequestRepository {
  /// Customer sends a request to a vendor (by vendorId UUID).
  Future<LinkRequestModel> sendRequest({
    required String vendorId,
    String? message,
  });

  /// Customer sends a request to a vendor by phone number or email.
  Future<LinkRequestModel> customerSendByIdentifier({
    required String vendorIdentifier,
    String? nickname,
    String? message,
  });

  /// Vendor sends a request to a customer (by email or 10-digit phone).
  Future<LinkRequestModel> vendorSendRequest({
    required String customerIdentifier,
    String? nickname,
    String? message,
  });

  Future<LinkRequestModel> acceptRequest(String requestId);

  Future<LinkRequestModel> declineRequest(String requestId);

  Future<LinkRequestModel> getRequestById(String requestId);

  Future<List<LinkRequestModel>> getPendingRequests();          // vendor: customer-initiated pending
  Future<List<LinkRequestModel>> getVendorSentRequests();       // vendor: vendor-initiated pending (awaiting customer)
  Future<List<LinkRequestModel>> getPendingForCustomer();       // customer: vendor-initiated pending
  Future<List<LinkRequestModel>> getSentRequests();             // customer: requests they sent
}
