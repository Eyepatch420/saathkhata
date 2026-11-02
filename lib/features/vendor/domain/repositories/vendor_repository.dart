import '../../../../shared/models/link_model.dart';
import '../../../../shared/models/report_models.dart';

abstract class VendorRepository {
  Future<List<CustomerLinkItem>> getLinkedCustomers();
  /// Fetches a single linked customer by linkId (e.g. from the members
  /// dashboard, which only carries a linkId, not the full customer summary).
  Future<CustomerLinkItem> getCustomerByLinkId(String linkId);
  /// Links where this vendor user is the customer (vendor-to-vendor connections).
  Future<List<VendorLinkItem>> getLinkedVendors();
  Future<void> deactivateLink(String linkId);
  /// Update the caller's nickname on a link. Pass null to clear.
  Future<void> updateLinkNickname(String linkId, String? nickname);

  /// Vendor sets per-customer default delivery product/qty.
  Future<void> updateLinkDefaults(
    String linkId, {
    String? defaultProduct,
    String? defaultUnit,
    double? defaultQty,
    double? defaultPricePerUnit,
  });
  Future<VendorSummaryReport> getVendorSummary();
  Future<RemindAllResult> remindAll();

  /// GET /api/v1/reports/collected-today — payments received today (paginated)
  Future<PaginatedList<CollectedTodayItem>> getCollectedToday({
    required int page,
    required int limit,
  });

  /// GET /api/v1/reports/outstanding — customers with positive balance (paginated)
  Future<PaginatedList<CustomerReportItem>> getOutstandingCustomers({
    required int page,
    required int limit,
  });

  /// GET /api/v1/reports/customers — all customers ranked by balance (for reports)
  Future<List<CustomerReportItem>> getAllCustomersReport();

  /// GET /api/v1/reports/customers/:linkId — full customer detail with monthly breakdown
  Future<CustomerDetailReport> getCustomerDetail(String linkId);

  /// GET /api/v1/reports/monthly?year= — 12-month revenue trend
  Future<MonthlyRevenueReport> getMonthlyRevenue(int year);
}
