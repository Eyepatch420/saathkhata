import 'package:equatable/equatable.dart';
import '../../../../shared/models/ledger_entry.dart';

class LedgerFilter extends Equatable {
  final EntryStatus? status;
  final EntryType? type;
  final bool deliveriesOnly;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final double? amountMin;
  final double? amountMax;

  const LedgerFilter({
    this.status,
    this.type,
    this.deliveriesOnly = false,
    this.dateFrom,
    this.dateTo,
    this.amountMin,
    this.amountMax,
  });

  bool get isEmpty =>
      status == null &&
      type == null &&
      !deliveriesOnly &&
      dateFrom == null &&
      dateTo == null &&
      amountMin == null &&
      amountMax == null;

  int get activeCount {
    int n = 0;
    if (status != null) n++;
    if (type != null || deliveriesOnly) n++;
    if (dateFrom != null || dateTo != null) n++;
    if (amountMin != null || amountMax != null) n++;
    return n;
  }

  Map<String, dynamic> toQueryParams() => {
        if (status != null) 'status': status!.toJson(),
        if (type != null && !deliveriesOnly) 'type': type!.toJson(),
        if (dateFrom != null) 'from': dateFrom!.toUtc().toIso8601String(),
        if (dateTo != null) 'to': dateTo!.toUtc().toIso8601String(),
        if (amountMin != null) 'amount_min': amountMin,
        if (amountMax != null) 'amount_max': amountMax,
      };

  LedgerFilter copyWith({
    EntryStatus? status,
    EntryType? type,
    bool? deliveriesOnly,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? amountMin,
    double? amountMax,
    bool clearStatus = false,
    bool clearType = false,
    bool clearDates = false,
    bool clearAmount = false,
  }) =>
      LedgerFilter(
        status: clearStatus ? null : (status ?? this.status),
        type: clearType ? null : (type ?? this.type),
        deliveriesOnly: clearType ? false : (deliveriesOnly ?? this.deliveriesOnly),
        dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
        dateTo: clearDates ? null : (dateTo ?? this.dateTo),
        amountMin: clearAmount ? null : (amountMin ?? this.amountMin),
        amountMax: clearAmount ? null : (amountMax ?? this.amountMax),
      );

  @override
  List<Object?> get props =>
      [status, type, deliveriesOnly, dateFrom, dateTo, amountMin, amountMax];
}

class LedgerPageResult {
  final List<LedgerEntry> entries;
  final int total;
  const LedgerPageResult({required this.entries, required this.total});
}
