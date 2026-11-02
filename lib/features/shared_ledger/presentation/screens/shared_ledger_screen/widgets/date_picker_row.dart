import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Tappable row showing the selected entry date, with a "Past date" badge
/// when [selectedDate] is before today. Used by both the single-entry and
/// multi-item add sheets.
class LedgerDatePickerRow extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const LedgerDatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  String _label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (selectedDate == null) return l10n.today;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    if (d == today) return l10n.today;
    if (d == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    if (d.year == now.year) return DateFormat('EEE, d MMM').format(d);
    return DateFormat('d MMM yyyy').format(d);
  }

  bool get _isPast {
    if (selectedDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    ).isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              _label(context),
              style: TextStyle(
                color: _isPast ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            if (_isPast) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.of(context)!.pastDateLabel,
                  style: const TextStyle(
                      fontSize: 10, color: Colors.deepOrange),
                ),
              ),
            ],
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
