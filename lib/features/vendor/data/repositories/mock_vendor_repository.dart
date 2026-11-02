import '../../domain/repositories/vendor_repository.dart';
import '../../../../shared/models/link_model.dart';
import '../../../../shared/models/report_models.dart';

class MockVendorRepository implements VendorRepository {
  final List<CustomerLinkItem> _links = [
    CustomerLinkItem(
      linkId: 'link1',
      balance: 1250.0,
      customer: const UserSummary(
        id: 'c1',
        name: 'Sujeet Kumar',
        mobile: '9876543210',
      ),
      createdAt: '2026-01-15T00:00:00.000Z',
    ),
    CustomerLinkItem(
      linkId: 'link2',
      balance: 3400.0,
      customer: const UserSummary(
        id: 'c2',
        name: 'Ramesh Singh',
        mobile: '9988776655',
      ),
      createdAt: '2026-02-01T00:00:00.000Z',
    ),
    CustomerLinkItem(
      linkId: 'link3',
      balance: 0.0,
      customer: const UserSummary(
        id: 'c3',
        name: 'Anjali Sharma',
        mobile: '9123456789',
      ),
      createdAt: '2026-03-10T00:00:00.000Z',
    ),
  ];

  @override
  Future<List<VendorLinkItem>> getLinkedVendors() async => [];

  @override
  Future<List<CustomerLinkItem>> getLinkedCustomers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_links);
  }

  @override
  Future<CustomerLinkItem> getCustomerByLinkId(String linkId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _links.firstWhere((l) => l.linkId == linkId);
  }

  @override
  Future<void> updateLinkNickname(String linkId, String? nickname) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> updateLinkDefaults(
    String linkId, {
    String? defaultProduct,
    String? defaultUnit,
    double? defaultQty,
    double? defaultPricePerUnit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> deactivateLink(String linkId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _links.removeWhere((l) => l.linkId == linkId);
  }

  @override
  Future<VendorSummaryReport> getVendorSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final total = _links.fold(0.0, (sum, l) => sum + l.balance);
    return VendorSummaryReport(
      totalOutstanding: total,
      totalCollectedThisMonth: 0,
      totalCollectedToday: 0,
      totalCreditThisMonth: 0,
      activeCustomerCount: _links.length,
      topCustomers: [],
    );
  }

  @override
  Future<RemindAllResult> remindAll() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final count = _links.where((l) => l.balance > 0).length;
    return RemindAllResult(queued: count, customersCount: count);
  }

  @override
  Future<PaginatedList<CollectedTodayItem>> getCollectedToday({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (page > 1) return const PaginatedList(items: [], hasMore: false);
    return PaginatedList(
      hasMore: false,
      items: [
        CollectedTodayItem(
          linkId: 'link1',
          customerName: 'Sujeet Kumar',
          customerPhone: '9876543210',
          amount: 500.0,
          paidAt: DateTime.now().toIso8601String(),
        ),
        CollectedTodayItem(
          linkId: 'link2',
          customerName: 'Ramesh Singh',
          customerPhone: '9988776655',
          amount: 1200.0,
          paidAt: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        ),
      ],
    );
  }

  @override
  Future<PaginatedList<CustomerReportItem>> getOutstandingCustomers({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (page > 1) return const PaginatedList(items: [], hasMore: false);
    return PaginatedList(
      hasMore: false,
      items: _links
          .where((l) => l.balance > 0)
          .map((l) => CustomerReportItem(
                linkId: l.linkId,
                customerId: l.customer.id,
                customerName: l.customer.name,
                customerPhone: l.customer.mobile,
                balance: l.balance,
                collectedThisMonth: 0,
              ))
          .toList(),
    );
  }

  @override
  Future<List<CustomerReportItem>> getAllCustomersReport() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _links
        .map((l) => CustomerReportItem(
              linkId: l.linkId,
              customerId: l.customer.id,
              customerName: l.customer.name,
              customerPhone: l.customer.mobile,
              balance: l.balance,
              collectedThisMonth: 0,
            ))
        .toList();
  }

  @override
  Future<CustomerDetailReport> getCustomerDetail(String linkId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final link = _links.firstWhere((l) => l.linkId == linkId);
    return CustomerDetailReport(
      linkId: linkId,
      customerId: link.customer.id,
      customerName: link.customer.name,
      balance: link.balance,
      totalCredit: link.balance,
      totalPaid: 0,
      pendingCount: 0,
      confirmedCount: 0,
      disputedCount: 0,
      monthlyBreakdown: [],
    );
  }

  @override
  Future<MonthlyRevenueReport> getMonthlyRevenue(int year) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MonthlyRevenueReport(year: year, months: []);
  }
}
