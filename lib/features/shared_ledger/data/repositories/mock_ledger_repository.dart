import 'dart:io';
import '../../domain/models/ledger_filter.dart';
import '../../domain/repositories/ledger_repository.dart';
import '../../../../shared/models/ledger_entry.dart';
import '../../../../shared/models/ledger_balance.dart';

class MockLedgerRepository implements LedgerRepository {
  final List<LedgerEntry> _entries = [
    LedgerEntry(
      id: 'e1',
      linkId: 'link1',
      vendorId: 'v1',
      customerId: 'c1',
      amount: 60.0,
      type: EntryType.credit,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: '2L Milk',
      quantity: 2,
      unit: 'litre',
      status: EntryStatus.confirmed,
      isLocked: true,
      confirmedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdBy: 'v1',
    ),
    LedgerEntry(
      id: 'e2',
      linkId: 'link1',
      vendorId: 'v1',
      customerId: 'c1',
      amount: 120.0,
      type: EntryType.credit,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: '4L Milk + Curd',
      quantity: 4,
      unit: 'litre',
      status: EntryStatus.pending,
      isLocked: false,
      createdBy: 'v1',
    ),
    LedgerEntry(
      id: 'e3',
      linkId: 'link1',
      vendorId: 'v1',
      customerId: 'c1',
      amount: 500.0,
      type: EntryType.payment,
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Monthly payment',
      status: EntryStatus.confirmed,
      isLocked: true,
      confirmedAt: DateTime.now().subtract(const Duration(days: 2)),
      createdBy: 'c1',
    ),
    LedgerEntry(
      id: 'e4',
      linkId: 'link1',
      vendorId: 'v1',
      customerId: 'c1',
      amount: 80.0,
      type: EntryType.credit,
      date: DateTime.now(),
      description: '2L Milk + Paneer 100g',
      status: EntryStatus.pending,
      isLocked: false,
      createdBy: 'v1',
    ),
    LedgerEntry(
      id: 'e5',
      linkId: 'link1',
      vendorId: 'v1',
      customerId: 'c1',
      amount: 45.0,
      type: EntryType.credit,
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: '1.5L Milk',
      status: EntryStatus.disputed,
      isLocked: false,
      disputeReason: 'Amount should be ₹40, not ₹45',
      createdBy: 'v1',
    ),
  ];

  @override
  Future<LedgerPageResult> getEntries(
    String linkId, {
    int page = 1,
    int limit = 50,
    LedgerFilter? filter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final entries = _entries
        .where((e) => e.linkId == linkId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return LedgerPageResult(entries: entries, total: entries.length);
  }

  @override
  Future<LedgerEntry> addEntry(LedgerEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newEntry = LedgerEntry(
      id: 'e${_entries.length + 1}',
      linkId: entry.linkId,
      vendorId: entry.vendorId,
      customerId: entry.customerId,
      amount: entry.amount,
      type: entry.type,
      date: entry.date,
      description: entry.description,
      quantity: entry.quantity,
      unit: entry.unit,
      status: EntryStatus.pending,
      isLocked: false,
      createdBy: entry.createdBy,
    );
    _entries.add(newEntry);
    return newEntry;
  }

  @override
  Future<LedgerEntry> confirmEntry(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _entries.indexWhere((e) => e.id == entryId);
    if (index == -1) throw Exception('Entry not found');
    final confirmed = LedgerEntry(
      id: _entries[index].id,
      linkId: _entries[index].linkId,
      vendorId: _entries[index].vendorId,
      customerId: _entries[index].customerId,
      amount: _entries[index].amount,
      type: _entries[index].type,
      date: _entries[index].date,
      description: _entries[index].description,
      quantity: _entries[index].quantity,
      unit: _entries[index].unit,
      status: EntryStatus.confirmed,
      isLocked: true,
      confirmedAt: DateTime.now(),
      createdBy: _entries[index].createdBy,
    );
    _entries[index] = confirmed;
    return confirmed;
  }

  @override
  Future<LedgerBalance> getBalance(String linkId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final result = await getEntries(linkId);
    final entries = result.entries;
    double credit = 0;
    double paid = 0;
    for (final e in entries) {
      if (e.type == EntryType.credit) credit += e.amount;
      if (e.type == EntryType.payment) paid += e.amount;
    }
    return LedgerBalance(
      linkId: linkId,
      balance: credit - paid,
      pendingCount: entries.where((e) => e.status == EntryStatus.pending).length,
      confirmedCount: entries.where((e) => e.status == EntryStatus.confirmed).length,
      disputedCount: entries.where((e) => e.status == EntryStatus.disputed).length,
      totalCreditAmount: credit,
      totalPaymentAmount: paid,
    );
  }

  @override
  Future<LedgerEntry> attachToEntry(String entryId, String linkId, File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _entries.indexWhere((e) => e.id == entryId);
    if (index == -1) throw Exception('Entry not found');
    final updated = LedgerEntry(
      id: _entries[index].id,
      linkId: _entries[index].linkId,
      vendorId: _entries[index].vendorId,
      customerId: _entries[index].customerId,
      amount: _entries[index].amount,
      type: _entries[index].type,
      date: _entries[index].date,
      description: _entries[index].description,
      quantity: _entries[index].quantity,
      unit: _entries[index].unit,
      status: _entries[index].status,
      isLocked: _entries[index].isLocked,
      confirmedAt: _entries[index].confirmedAt,
      disputeReason: _entries[index].disputeReason,
      attachmentUrl: 'https://res.cloudinary.com/mock/ledger_attachments/mock_proof.jpg',
      createdBy: _entries[index].createdBy,
    );
    _entries[index] = updated;
    return updated;
  }

  @override
  Future<LedgerEntry> disputeEntry(String entryId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _entries.indexWhere((e) => e.id == entryId);
    if (index == -1) throw Exception('Entry not found');
    final disputed = LedgerEntry(
      id: _entries[index].id,
      linkId: _entries[index].linkId,
      vendorId: _entries[index].vendorId,
      customerId: _entries[index].customerId,
      amount: _entries[index].amount,
      type: _entries[index].type,
      date: _entries[index].date,
      description: _entries[index].description,
      quantity: _entries[index].quantity,
      unit: _entries[index].unit,
      status: EntryStatus.disputed,
      isLocked: false,
      disputeReason: reason,
      createdBy: _entries[index].createdBy,
    );
    _entries[index] = disputed;
    return disputed;
  }
}
