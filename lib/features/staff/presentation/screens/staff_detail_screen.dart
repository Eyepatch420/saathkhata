import 'package:flutter/cupertino.dart'
    show CupertinoPicker, FixedExtentScrollController;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/staff_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import 'staff_detail_screen/widgets/app_access_card.dart';
import 'staff_detail_screen/widgets/salary_history_section.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';

class StaffDetailScreen extends StatelessWidget {
  final StaffModel staff;
  const StaffDetailScreen({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (context) => StaffBloc(getIt())
        ..add(
          LoadAttendance(
            staffId: staff.id,
            year: now.year,
            month: now.month,
            staff: staff,
          ),
        ),
      child: _StaffDetailView(initialStaff: staff),
    );
  }
}

class _StaffDetailView extends StatelessWidget {
  final StaffModel initialStaff;
  const _StaffDetailView({required this.initialStaff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<StaffBloc, StaffState>(
      listener: (context, state) {
        if (state is StaffDeleted) {
          AppToast.show(
            context,
            '${state.staffName} has been removed',
            type: ToastType.info,
          );
          Navigator.of(context).pop();
        } else if (state is StaffError) {
          AppToast.show(context, state.message, type: ToastType.error);
        }
      },
      builder: (context, state) {
        final staff = state is StaffDetailLoaded ? state.staff : initialStaff;
        final attendance = state is StaffDetailLoaded
            ? state.attendance
            : <String, AttendanceStatus>{};
        final year = state is StaffDetailLoaded
            ? state.year
            : DateTime.now().year;
        final month = state is StaffDetailLoaded
            ? state.month
            : DateTime.now().month;

        return Scaffold(
          appBar: AppBar(
            title: Text(staff.name),
            actions: [
              if (staff.unpaidSalary > 0)
                TextButton.icon(
                  onPressed: () => _showPaySalarySheet(context, staff),
                  icon: const Icon(Icons.payment_rounded, size: 18),
                  label: Text(l10n.staffPayButton),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                tooltip: AppLocalizations.of(context)!.removeStaffTooltip,
                onPressed: () => _confirmDelete(context, staff),
              ),
            ],
          ),
          body: SafeArea(
            child: state is StaffLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileCard(staff: staff),
                        const SizedBox(height: 16),
                        _SalaryCard(
                          staff: staff,
                          attendance: attendance,
                          year: year,
                          month: month,
                        ),
                        const SizedBox(height: 16),
                        AppAccessCard(staff: staff),
                        const SizedBox(height: 16),
                        _AttendanceCalendar(
                          staffId: staff.id,
                          attendance: attendance,
                          year: year,
                          month: month,
                          joinDate: staff.joinDate,
                          onMonthChanged: (y, m) =>
                              context.read<StaffBloc>().add(
                                LoadAttendance(
                                  staffId: staff.id,
                                  year: y,
                                  month: m,
                                ),
                              ),
                        ),
                        const SizedBox(height: 16),
                        _ActionButtons(staff: staff),
                        const SizedBox(height: 24),
                        SalaryHistorySection(
                          staffId: staff.id,
                          // Re-fetch whenever a payment/advance changes the balances.
                          refreshKey:
                              '${staff.unpaidSalary}_${staff.advanceTaken}',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, StaffModel staff) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeStaffTitle),
        content: Text(l10n.removeStaffConfirm(staff.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<StaffBloc>().add(DeleteStaff(staffId: staff.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              l10n.remove,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaySalarySheet(BuildContext context, StaffModel staff) {
    final bloc = context.read<StaffBloc>();
    final router = GoRouter.of(context);
    final l10n = AppLocalizations.of(context)!;
    final amountCtrl = TextEditingController(
      text: staff.unpaidSalary.toStringAsFixed(0),
    );
    final upiCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          // viewInsets clears the keyboard; viewPadding clears the gesture
          // bar / 3-button nav when the keyboard is closed.
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.paySalaryTitle, style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              l10n.unpaidLabel(staff.unpaidSalary.toStringAsFixed(0)),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amountRupees,
                prefixIcon: const Icon(Icons.currency_rupee_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: upiCtrl,
              decoration: InputDecoration(
                labelText: l10n.upiTransactionIdOptional,
                prefixIcon: const Icon(Icons.qr_code_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount <= 0) return;
                  Navigator.pop(ctx);
                  bloc.add(
                    PaySalary(
                      staffId: staff.id,
                      amount: amount,
                      upiTransactionId: upiCtrl.text.trim().isEmpty
                          ? null
                          : upiCtrl.text.trim(),
                    ),
                  );
                  router.push(
                    AppRouter.upiPayment,
                    extra: {
                      'amount': amount,
                      'recipientName': staff.name,
                      'upiId': null,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.paymentConfirmed,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final StaffModel staff;
  const _ProfileCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final joinedDate = DateFormat('MMM yyyy', locale).format(staff.joinDate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              staff.name[0],
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(staff.name, style: AppTypography.h3),
                const SizedBox(height: 2),
                Text(
                  staff.role,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      staff.phone.isEmpty ? l10n.noPhone : staff.phone,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.staffJoined(joinedDate),
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: staff.isActive
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              staff.isActive ? l10n.active : l10n.inactive,
              style: AppTypography.bodySmall.copyWith(
                color: staff.isActive ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryCard extends StatelessWidget {
  final StaffModel staff;
  final Map<String, AttendanceStatus> attendance;
  final int year;
  final int month;

  const _SalaryCard({
    required this.staff,
    required this.attendance,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daysPresent = attendance.values
        .where((s) => s == AttendanceStatus.present)
        .length;
    final halfDays = attendance.values
        .where((s) => s == AttendanceStatus.halfDay)
        .length;
    final effectiveDays = daysPresent + (halfDays * 0.5);

    final earned = staff.salaryType == SalaryType.daily
        ? effectiveDays * staff.salaryAmount
        : staff.salaryAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.salaryTitle, style: AppTypography.labelLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              _SalaryStat(
                label: l10n.rate,
                value: staff.salaryType == SalaryType.daily
                    ? l10n.staffSalaryPerDay(
                        staff.salaryAmount.toStringAsFixed(0),
                      )
                    : l10n.staffSalaryPerMonth(
                        staff.salaryAmount.toStringAsFixed(0),
                      ),
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              _SalaryStat(
                label: l10n.daysPresent,
                value: daysPresent + halfDays > 0
                    ? effectiveDays.toStringAsFixed(1)
                    : '0',
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              _SalaryStat(
                label: l10n.earned,
                value: '₹${earned.toStringAsFixed(0)}',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
          if (staff.unpaidSalary > 0 || staff.advanceTaken > 0) ...[
            const Divider(height: 24),
            Row(
              children: [
                if (staff.unpaidSalary > 0)
                  Expanded(
                    child: _SalaryStat(
                      label: l10n.unpaid,
                      value: '₹${staff.unpaidSalary.toStringAsFixed(0)}',
                      color: AppColors.error,
                    ),
                  ),
                if (staff.advanceTaken > 0)
                  Expanded(
                    child: _SalaryStat(
                      label: l10n.advanceTaken,
                      value: '₹${staff.advanceTaken.toStringAsFixed(0)}',
                      color: AppColors.warning,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SalaryStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SalaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text(value, style: AppTypography.labelLarge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _AttendanceCalendar extends StatefulWidget {
  final String staffId;
  final Map<String, AttendanceStatus> attendance;
  final int year;
  final int month;
  final DateTime joinDate;
  final void Function(int year, int month) onMonthChanged;

  const _AttendanceCalendar({
    required this.staffId,
    required this.attendance,
    required this.year,
    required this.month,
    required this.joinDate,
    required this.onMonthChanged,
  });

  @override
  State<_AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<_AttendanceCalendar> {
  void _showMonthYearPicker(BuildContext context) {
    final now = DateTime.now();
    final firstYear = widget.joinDate.year;
    final lastYear = now.year;

    // Build list of valid (year, month) pairs
    final months = <DateTime>[];
    for (int y = firstYear; y <= lastYear; y++) {
      final startMonth = (y == firstYear) ? widget.joinDate.month : 1;
      final endMonth = (y == lastYear) ? now.month : 12;
      for (int m = startMonth; m <= endMonth; m++) {
        months.add(DateTime(y, m));
      }
    }

    int selectedIndex = months.indexWhere(
      (d) => d.year == widget.year && d.month == widget.month,
    );
    if (selectedIndex < 0) selectedIndex = months.length - 1;

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        int pickerIndex = selectedIndex;
        return SafeArea(
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.cancel),
                      ),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          widget.onMonthChanged(
                            months[pickerIndex].year,
                            months[pickerIndex].month,
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedIndex,
                    ),
                    itemExtent: 44,
                    onSelectedItemChanged: (i) => pickerIndex = i,
                    children: months
                        .map(
                          (d) => Center(
                            child: Text(
                              DateFormat('MMMM yyyy', locale).format(d),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final monthLabel = DateFormat(
      'MMMM yyyy',
      locale,
    ).format(DateTime(widget.year, widget.month));
    final daysInMonth = DateTime(widget.year, widget.month + 1, 0).day;
    final firstWeekday = DateTime(widget.year, widget.month, 1).weekday % 7;

    final now = DateTime.now();
    final joinFirst = DateTime(widget.joinDate.year, widget.joinDate.month);
    final current = DateTime(widget.year, widget.month);
    final canGoPrev = current.isAfter(joinFirst);
    final canGoNext =
        current.year < now.year ||
        (current.year == now.year && current.month < now.month);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.attendanceTitle, style: AppTypography.labelLarge),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: canGoPrev ? null : AppColors.textHint,
                ),
                onPressed: canGoPrev
                    ? () {
                        final prev = DateTime(widget.year, widget.month - 1);
                        widget.onMonthChanged(prev.year, prev.month);
                      }
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showMonthYearPicker(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      monthLabel,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down_rounded, size: 18),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: canGoNext ? null : AppColors.textHint,
                ),
                onPressed: canGoNext
                    ? () {
                        final next = DateTime(widget.year, widget.month + 1);
                        widget.onMonthChanged(next.year, next.month);
                      }
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox();
              final day = index - firstWeekday + 1;
              final key =
                  '${widget.year}-${widget.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
              final status = widget.attendance[key];
              final cellDate = DateTime(widget.year, widget.month, day);
              final isToday =
                  now.year == widget.year &&
                  now.month == widget.month &&
                  now.day == day;
              final isFuture = cellDate.isAfter(
                DateTime(now.year, now.month, now.day),
              );
              return _DayCell(
                day: day,
                status: status,
                isToday: isToday,
                onTap: isFuture
                    ? null
                    : () => _showMarkSheet(
                        context,
                        widget.staffId,
                        cellDate,
                        status,
                      ),
              );
            },
          ),
          const SizedBox(height: 12),
          const _CalendarLegend(),
        ],
      ),
    );
  }

  void _showMarkSheet(
    BuildContext context,
    String staffId,
    DateTime date,
    AttendanceStatus? current,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<StaffBloc>();
    final dateLabel = '${date.day}/${date.month}/${date.year}';

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.markAttendanceFor(dateLabel),
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: 16),
              _AttendanceOption(
                label: l10n.present,
                color: AppColors.success,
                icon: Icons.check_circle_outline_rounded,
                selected: current == AttendanceStatus.present,
                onTap: () {
                  Navigator.pop(ctx);
                  bloc.add(
                    MarkAttendance(
                      staffId: staffId,
                      date: date,
                      status: AttendanceStatus.present,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _AttendanceOption(
                label: l10n.halfDay,
                color: AppColors.warning,
                icon: Icons.timelapse_rounded,
                selected: current == AttendanceStatus.halfDay,
                onTap: () {
                  Navigator.pop(ctx);
                  bloc.add(
                    MarkAttendance(
                      staffId: staffId,
                      date: date,
                      status: AttendanceStatus.halfDay,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _AttendanceOption(
                label: l10n.absent,
                color: AppColors.error,
                icon: Icons.cancel_outlined,
                selected: current == AttendanceStatus.absent,
                onTap: () {
                  Navigator.pop(ctx);
                  bloc.add(
                    MarkAttendance(
                      staffId: staffId,
                      date: date,
                      status: AttendanceStatus.absent,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceOption extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AttendanceOption({
    required this.label,
    required this.color,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: selected ? 0.18 : 0.07),
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.labelLarge.copyWith(color: color)),
            if (selected) ...[
              const Spacer(),
              Icon(Icons.check_rounded, color: color, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final AttendanceStatus? status;
  final bool isToday;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.status,
    required this.isToday,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status) {
      case AttendanceStatus.present:
        bg = AppColors.success;
        text = Colors.white;
      case AttendanceStatus.absent:
        bg = AppColors.error;
        text = Colors.white;
      case AttendanceStatus.halfDay:
        bg = AppColors.warning;
        text = Colors.white;
      case AttendanceStatus.holiday:
        bg = AppColors.textHint.withValues(alpha: 0.3);
        text = AppColors.textSecondary;
      case null:
        bg = isToday
            ? AppColors.primary.withValues(alpha: 0.15)
            : Colors.transparent;
        text = isToday
            ? AppColors.primary
            : Theme.of(context).colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: isToday && status == null
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: AppTypography.bodySmall.copyWith(
              color: text,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _LegendItem(color: AppColors.success, label: l10n.present),
        const SizedBox(width: 12),
        _LegendItem(color: AppColors.error, label: l10n.absent),
        const SizedBox(width: 12),
        _LegendItem(color: AppColors.warning, label: l10n.halfDay),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final StaffModel staff;
  const _ActionButtons({required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showAdvanceSheet(context, staff),
                icon: const Icon(Icons.add_card_rounded, size: 18),
                label: Text(l10n.addAdvance),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: const BorderSide(color: AppColors.warning),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: staff.unpaidSalary > 0
                    ? () => _showPaySalaryFromButtons(context, staff)
                    : null,
                icon: const Icon(Icons.payment_rounded, size: 18),
                label: Text(
                  staff.unpaidSalary > 0
                      ? l10n.staffPayAmount(
                          staff.unpaidSalary.toStringAsFixed(0),
                        )
                      : l10n.noDues,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        if (staff.salaryType == SalaryType.monthly && staff.isActive) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmAccrue(context, staff),
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: Text(
                l10n.accrueMonthSalary(staff.salaryAmount.toStringAsFixed(0)),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _confirmAccrue(BuildContext context, StaffModel staff) {
    final bloc = context.read<StaffBloc>();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accrueMonthSalaryTitle),
        content: Text(
          l10n.accrueMonthSalaryConfirm(
            staff.name,
            staff.salaryAmount.toStringAsFixed(0),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(AccrueSalary(staffId: staff.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvanceSheet(BuildContext context, StaffModel staff) {
    final bloc = context.read<StaffBloc>();
    final l10n = AppLocalizations.of(context)!;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          // viewInsets clears the keyboard; viewPadding clears the gesture
          // bar / 3-button nav when the keyboard is closed.
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.addAdvance, style: AppTypography.h3),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amountRupees,
                prefixIcon: const Icon(Icons.currency_rupee_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(
                labelText: l10n.noteOptional,
                prefixIcon: const Icon(Icons.note_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount <= 0) return;
                  Navigator.pop(ctx);
                  bloc.add(
                    AddAdvance(
                      staffId: staff.id,
                      amount: amount,
                      note: noteCtrl.text.trim().isEmpty
                          ? null
                          : noteCtrl.text.trim(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.addAdvanceTitle,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaySalaryFromButtons(BuildContext context, StaffModel staff) {
    final bloc = context.read<StaffBloc>();
    final router = GoRouter.of(context);
    final l10n = AppLocalizations.of(context)!;
    final amountCtrl = TextEditingController(
      text: staff.unpaidSalary.toStringAsFixed(0),
    );
    final upiCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          // viewInsets clears the keyboard; viewPadding clears the gesture
          // bar / 3-button nav when the keyboard is closed.
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom +
              24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.paySalaryTitle, style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              l10n.unpaidLabel(staff.unpaidSalary.toStringAsFixed(0)),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amountRupees,
                prefixIcon: const Icon(Icons.currency_rupee_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: upiCtrl,
              decoration: InputDecoration(
                labelText: l10n.upiTransactionIdOptional,
                prefixIcon: const Icon(Icons.qr_code_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount <= 0) return;
                  Navigator.pop(ctx);
                  bloc.add(
                    PaySalary(
                      staffId: staff.id,
                      amount: amount,
                      upiTransactionId: upiCtrl.text.trim().isEmpty
                          ? null
                          : upiCtrl.text.trim(),
                    ),
                  );
                  router.push(
                    AppRouter.upiPayment,
                    extra: {
                      'amount': amount,
                      'recipientName': staff.name,
                      'upiId': null,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.paymentConfirmed,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
