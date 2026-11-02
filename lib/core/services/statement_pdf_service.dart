import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../shared/models/ledger_entry.dart';

// ─── Date range enum ──────────────────────────────────────────────────────────

enum StatementDateRange {
  last7Days,
  last30Days,
  last3Months,
  allTime;

  String get label => switch (this) {
        last7Days => 'Last 7 Days',
        last30Days => 'Last 30 Days',
        last3Months => 'Last 3 Months',
        allTime => 'All Time',
      };

  DateTime? get fromDate => switch (this) {
        last7Days => DateTime.now().subtract(const Duration(days: 7)),
        last30Days => DateTime.now().subtract(const Duration(days: 30)),
        last3Months => DateTime.now().subtract(const Duration(days: 90)),
        allTime => null,
      };
}

// ─── PDF colour palette ───────────────────────────────────────────────────────

final _kPrimary = PdfColor.fromHex('#2563EB');
final _kSuccess = PdfColor.fromHex('#16A34A');
final _kError = PdfColor.fromHex('#DC2626');
final _kWarning = PdfColor.fromHex('#D97706');
final _kHeader = PdfColor.fromHex('#1E3A5F');
final _kSurface = PdfColor.fromHex('#F1F5F9');
final _kBorder = PdfColor.fromHex('#E2E8F0');
final _kMuted = PdfColor.fromHex('#64748B');
final _kAccentBlue = PdfColor.fromHex('#93C5FD');

// ─── Service ──────────────────────────────────────────────────────────────────

class StatementPdfService {
  StatementPdfService._();

  /// Returns raw PDF bytes for a ledger statement.
  static Future<List<int>> generate({
    required String vendorName,
    required String customerName,
    required List<LedgerEntry> allEntries,
    required StatementDateRange range,
    required double balance,
  }) async {
    final doc = pw.Document();

    // Filter by date range
    final cutoff = range.fromDate;
    final filtered = (cutoff == null
            ? List<LedgerEntry>.from(allEntries)
            : allEntries.where((e) => e.date.isAfter(cutoff)).toList())
      ..sort((a, b) => b.date.compareTo(a.date));

    final confirmed = filtered
        .where((e) =>
            e.status == EntryStatus.confirmed ||
            e.status == EntryStatus.autoConfirmed)
        .toList();

    final others = filtered
        .where((e) =>
            e.status != EntryStatus.confirmed &&
            e.status != EntryStatus.autoConfirmed)
        .toList();

    double totalCredit = 0;
    double totalPaid = 0;
    for (final e in confirmed) {
      if (e.type == EntryType.credit) totalCredit += e.amount;
      if (e.type == EntryType.payment) totalPaid += e.amount;
    }

    final generatedAt =
        DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final periodLabel = _periodLabel(range);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (_) => _buildHeader(
            vendorName, customerName, periodLabel, generatedAt),
        footer: (ctx) => _buildFooter(ctx),
        build: (_) => [
          pw.SizedBox(height: 18),
          _buildSummary(totalCredit, totalPaid, balance),
          pw.SizedBox(height: 26),
          if (confirmed.isNotEmpty) ...[
            _sectionBadge('Confirmed Transactions', _kSuccess),
            pw.SizedBox(height: 8),
            _confirmedTable(confirmed),
            pw.SizedBox(height: 24),
          ],
          if (others.isNotEmpty) ...[
            _sectionBadge('Other Entries  (Pending / Disputed)', _kWarning),
            pw.SizedBox(height: 6),
            _othersNote(),
            pw.SizedBox(height: 8),
            _othersTable(others),
          ],
          if (filtered.isEmpty) _emptyState(range),
        ],
      ),
    );

    return doc.save();
  }

  // ─── Page header ─────────────────────────────────────────────────────────

  static pw.Widget _buildHeader(
    String vendor,
    String customer,
    String period,
    String generated,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: pw.BoxDecoration(color: _kHeader),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left: brand
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('SaathKhata',
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('Ledger Statement',
                  style: pw.TextStyle(color: _kAccentBlue, fontSize: 10)),
            ],
          ),
          // Right: meta
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _meta('Vendor', vendor),
              pw.SizedBox(height: 2),
              _meta('Customer', customer),
              pw.SizedBox(height: 2),
              _meta('Period', period),
              pw.SizedBox(height: 2),
              _meta('Generated', generated),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _meta(String label, String value) => pw.RichText(
        text: pw.TextSpan(children: [
          pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(color: _kMuted, fontSize: 8)),
          pw.TextSpan(
              text: value,
              style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold)),
        ]),
      );

  // ─── Page footer ──────────────────────────────────────────────────────────

  static pw.Widget _buildFooter(pw.Context ctx) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
          border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('SaathKhata — Confidential',
              style: pw.TextStyle(fontSize: 7, color: _kMuted)),
          pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style: pw.TextStyle(fontSize: 7, color: _kMuted)),
        ],
      ),
    );
  }

  // ─── Summary boxes ────────────────────────────────────────────────────────

  static pw.Widget _buildSummary(
      double totalCredit, double totalPaid, double balance) {
    return pw.Row(
      children: [
        pw.Expanded(child: _box('Total Credit Given', 'Rs.${_f(totalCredit)}', _kError)),
        pw.SizedBox(width: 10),
        pw.Expanded(child: _box('Total Payments', 'Rs.${_f(totalPaid)}', _kSuccess)),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _box(
            'Outstanding',
            'Rs.${_f(balance.abs())}',
            balance > 0 ? _kError : _kSuccess,
            sub: balance > 0
                ? 'Customer owes'
                : balance < 0
                    ? 'You owe'
                    : 'Settled',
          ),
        ),
      ],
    );
  }

  static pw.Widget _box(String label, String value, PdfColor color,
      {String? sub}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _kSurface,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: _kBorder, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 8, color: _kMuted)),
          pw.SizedBox(height: 5),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: color)),
          if (sub != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(sub,
                style: pw.TextStyle(fontSize: 7, color: _kMuted)),
          ],
        ],
      ),
    );
  }

  // ─── Section badge ────────────────────────────────────────────────────────

  static pw.Widget _sectionBadge(String title, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: pw.BoxDecoration(
        color: PdfColor(color.red, color.green, color.blue, 0.08),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        border: pw.Border(left: pw.BorderSide(color: color, width: 3)),
      ),
      child: pw.Text(title,
          style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: color)),
    );
  }

  // ─── Confirmed table ──────────────────────────────────────────────────────

  static pw.Widget _confirmedTable(List<LedgerEntry> entries) {
    // Build rows manually so we can add a totals row
    final dataRows = entries.map((e) => [
          DateFormat('dd MMM yy').format(e.date),
          e.description ??
              (e.type == EntryType.credit ? 'Credit given' : 'Payment received'),
          e.type == EntryType.credit ? 'Credit' : 'Payment',
          e.quantity != null
              ? '${e.quantity!.toStringAsFixed(1)} ${e.unit ?? ''}'
              : '-',
          _f(e.amount),
        ]).toList();

    // Net of confirmed entries
    final net = entries.fold<double>(
        0, (s, e) => s + (e.type == EntryType.credit ? e.amount : -e.amount));
    dataRows.add(['', '', '', 'NET', _f(net)]);

    return pw.Table(
      border: pw.TableBorder.all(color: _kBorder, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(68),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FixedColumnWidth(56),
        3: const pw.FixedColumnWidth(48),
        4: const pw.FixedColumnWidth(68),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _kHeader),
          children: ['Date', 'Description', 'Type', 'Qty', 'Amount (Rs.)']
              .map((h) => _cell(h,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold),
                  isHeader: true))
              .toList(),
        ),
        // Data rows
        for (int i = 0; i < dataRows.length; i++)
          pw.TableRow(
            decoration: i == dataRows.length - 1
                ? pw.BoxDecoration(
                    color: PdfColor(_kPrimary.red, _kPrimary.green,
                        _kPrimary.blue, 0.08))
                : i.isOdd
                    ? pw.BoxDecoration(color: _kSurface)
                    : null,
            children: [
              for (int col = 0; col < dataRows[i].length; col++)
                _cell(
                  dataRows[i][col],
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: i == dataRows.length - 1
                        ? pw.FontWeight.bold
                        : null,
                    color: i == dataRows.length - 1 ? _kPrimary : null,
                  ),
                  align: col >= 3
                      ? pw.Alignment.centerRight
                      : pw.Alignment.centerLeft,
                ),
            ],
          ),
      ],
    );
  }

  // ─── Others table ─────────────────────────────────────────────────────────

  static pw.Widget _othersNote() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: pw.BoxDecoration(
        color: PdfColor(
            _kWarning.red, _kWarning.green, _kWarning.blue, 0.06),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        border: pw.Border.all(color: _kWarning, width: 0.5),
      ),
      child: pw.Text(
        'These entries are not fully confirmed. '
        'Open SaathKhata for full details and to confirm or dispute.',
        style: pw.TextStyle(fontSize: 8, color: _kWarning),
      ),
    );
  }

  static pw.Widget _othersTable(List<LedgerEntry> entries) {
    final headerBg = PdfColor.fromHex('#78716C');
    return pw.Table(
      border: pw.TableBorder.all(color: _kBorder, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(68),
        1: const pw.FixedColumnWidth(54),
        2: const pw.FixedColumnWidth(60),
        3: const pw.FixedColumnWidth(70),
        4: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: headerBg),
          children: ['Date', 'Type', 'Status', 'Amount (Rs.)', 'Note']
              .map((h) => _cell(h,
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold),
                  isHeader: true))
              .toList(),
        ),
        for (int i = 0; i < entries.length; i++)
          pw.TableRow(
            decoration:
                i.isOdd ? pw.BoxDecoration(color: _kSurface) : null,
            children: [
              _cell(DateFormat('dd MMM yy').format(entries[i].date)),
              _cell(entries[i].type == EntryType.credit ? 'Credit' : 'Payment',
                  align: pw.Alignment.center),
              _cell(_statusLabel(entries[i].status), align: pw.Alignment.center),
              _cell(_f(entries[i].amount), align: pw.Alignment.centerRight),
              _cell('Check app for details',
                  style: pw.TextStyle(fontSize: 8, color: _kMuted,
                      fontStyle: pw.FontStyle.italic)),
            ],
          ),
      ],
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────

  static pw.Widget _emptyState(StatementDateRange range) {
    return pw.Center(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 40),
        child: pw.Text(
          'No transactions found for ${range.label.toLowerCase()}.',
          style: pw.TextStyle(fontSize: 11, color: _kMuted),
        ),
      ),
    );
  }

  // ─── Table cell helper ────────────────────────────────────────────────────

  static pw.Widget _cell(
    String text, {
    pw.TextStyle? style,
    pw.Alignment align = pw.Alignment.centerLeft,
    bool isHeader = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      alignment: align,
      child: pw.Text(
        text,
        style: style ??
            pw.TextStyle(
                fontSize: 9, color: isHeader ? PdfColors.white : null),
      ),
    );
  }

  // ─── Utilities ────────────────────────────────────────────────────────────

  static String _f(double v) =>
      NumberFormat('#,##0.00', 'en_IN').format(v);

  static String _periodLabel(StatementDateRange range) {
    if (range == StatementDateRange.allTime) return 'All Time';
    final from = range.fromDate!;
    final to = DateTime.now();
    return '${DateFormat('dd MMM yyyy').format(from)} – '
        '${DateFormat('dd MMM yyyy').format(to)}';
  }

  static String _statusLabel(EntryStatus s) => switch (s) {
        EntryStatus.pending => 'Pending',
        EntryStatus.confirmed => 'Confirmed',
        EntryStatus.disputed => 'Disputed',
        EntryStatus.autoConfirmed => 'Auto-confirmed',
      };
}
