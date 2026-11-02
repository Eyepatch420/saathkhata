import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/staff_model.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../bloc/staff_bloc.dart';
import '../bloc/staff_event.dart';
import '../bloc/staff_state.dart';
import 'staff_detail_screen.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffBloc(getIt())..add(LoadStaff()),
      child: const _StaffView(),
    );
  }
}

class _StaffView extends StatefulWidget {
  const _StaffView();

  @override
  State<_StaffView> createState() => _StaffViewState();
}

class _StaffViewState extends State<_StaffView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabAnim;
  late final Animation<double> _fabScale;
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 0 && _fabVisible) {
        _fabVisible = false;
        _fabAnim.reverse();
      } else if (delta < 0 && !_fabVisible) {
        _fabVisible = true;
        _fabAnim.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.staffAndLabour)),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: BlocBuilder<StaffBloc, StaffState>(
            builder: (context, state) {
              if (state is StaffLoading || state is StaffActionLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is StaffError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => context.read<StaffBloc>().add(LoadStaff()),
                );
              }
              if (state is StaffLoaded) {
                return _StaffContent(state: state);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      // Shell uses extendBody, so padding.bottom carries the pill nav height —
      // lift the FAB above it like the dashboard FAB.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: FadeTransition(
          opacity: _fabAnim,
          child: ScaleTransition(
            scale: _fabScale,
            child: FloatingActionButton.extended(
              onPressed: () => _showAddStaffSheet(context),
              label: Text(l10n.addStaff),
              icon: const Icon(Icons.person_add_rounded),
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    final bloc = context.read<StaffBloc>();
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    String selectedRole = 'Helper';
    SalaryType selectedType = SalaryType.daily;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
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
              Text(l10n.addNewStaff, style: AppTypography.h3),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.fullNameLabel,
                  prefixIcon: const Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  prefixIcon: const Icon(Icons.phone_rounded),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: l10n.role,
                  prefixIcon: const Icon(Icons.work_rounded),
                ),
                items:
                    [
                          'Helper',
                          'Cook',
                          'Delivery',
                          'Driver',
                          'Guard',
                          'Cleaner',
                          'Other',
                        ]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                onChanged: (v) => setState(() => selectedRole = v!),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<SalaryType>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  labelText: l10n.salaryType,
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                ),
                items: [
                  DropdownMenuItem(
                    value: SalaryType.daily,
                    child: Text(l10n.dailyWage),
                  ),
                  DropdownMenuItem(
                    value: SalaryType.monthly,
                    child: Text(l10n.monthlySalary),
                  ),
                ],
                onChanged: (v) => setState(() => selectedType = v!),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: salaryCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: selectedType == SalaryType.daily
                      ? l10n.dailyWageAmount
                      : l10n.monthlySalaryAmount,
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final phone = phoneCtrl.text.trim();
                    final salary = double.tryParse(salaryCtrl.text) ?? 0;
                    if (name.isEmpty) return;
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(l10n.invalidPhone),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    if (salary <= 0) return;
                    Navigator.pop(ctx);
                    bloc.add(
                      AddStaff(
                        StaffModel(
                          id: '',
                          vendorId: '',
                          name: name,
                          phone: phone,
                          role: selectedRole,
                          salaryType: selectedType,
                          salaryAmount: salary,
                          joinDate: DateTime.now(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    l10n.addStaffButton,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffContent extends StatelessWidget {
  final StaffLoaded state;
  const _StaffContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (state.staffList.isEmpty) {
      // Refreshable empty state — pull down to re-check the server.
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<StaffBloc>().add(RefreshStaff());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyStateWidget(
                icon: Icons.people_outline_rounded,
                title: l10n.noStaffAdded,
                subtitle: l10n.noStaffAddedSubtitle,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _StaffSummaryBar(state: state),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              // RefreshStaff reloads silently (keeps the list visible). We don't
              // await a specific state because StaffLoaded is Equatable and an
              // identical refetch would be deduplicated, hanging firstWhere().
              context.read<StaffBloc>().add(RefreshStaff());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 88,
              ),
              itemCount: state.staffList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _StaffCard(staff: state.staffList[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StaffSummaryBar extends StatelessWidget {
  final StaffLoaded state;
  const _StaffSummaryBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          _SummaryItem(
            label: l10n.presentToday,
            value: '${state.presentCount}/${state.staffList.length}',
            color: AppColors.success,
            icon: Icons.check_circle_rounded,
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 40, color: AppColors.divider),
          const SizedBox(width: 16),
          _SummaryItem(
            label: l10n.unpaidSalary,
            value: '₹${state.totalUnpaidSalary.toStringAsFixed(0)}',
            color: AppColors.error,
            icon: Icons.account_balance_wallet_rounded,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text(value, style: AppTypography.labelLarge.copyWith(color: color)),
          ],
        ),
      ],
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffModel staff;
  const _StaffCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final salaryDisplay = staff.salaryType == SalaryType.daily
        ? l10n.staffSalaryPerDay(staff.salaryAmount.toStringAsFixed(0))
        : l10n.staffSalaryPerMonth(staff.salaryAmount.toStringAsFixed(0));

    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .push(
            MaterialPageRoute(builder: (_) => StaffDetailScreen(staff: staff)),
          )
          .then((_) {
            if (context.mounted) context.read<StaffBloc>().add(LoadStaff());
          }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  radius: 24,
                  child: Text(
                    staff.name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.name, style: AppTypography.labelLarge),
                      Text(
                        '${staff.role} • $salaryDisplay',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          staff.presentToday
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 14,
                          color: staff.presentToday
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          staff.presentToday ? l10n.present : l10n.absent,
                          style: AppTypography.bodySmall.copyWith(
                            color: staff.presentToday
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.unpaidSalary, style: AppTypography.bodySmall),
                    Text(
                      '₹${staff.unpaidSalary.toStringAsFixed(0)}',
                      style: AppTypography.h3.copyWith(color: AppColors.error),
                    ),
                  ],
                ),
                if (staff.advanceTaken > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.advanceTaken, style: AppTypography.bodySmall),
                      Text(
                        '₹${staff.advanceTaken.toStringAsFixed(0)}',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                _AttendanceTodayButton(staff: staff),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTodayButton extends StatelessWidget {
  final StaffModel staff;
  const _AttendanceTodayButton({required this.staff});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<AttendanceStatus>(
      onSelected: (status) {
        context.read<StaffBloc>().add(
          MarkAttendance(
            staffId: staff.id,
            date: DateTime.now(),
            status: status,
          ),
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AttendanceStatus.present,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(l10n.present),
            ],
          ),
        ),
        PopupMenuItem(
          value: AttendanceStatus.absent,
          child: Row(
            children: [
              const Icon(
                Icons.cancel_rounded,
                color: AppColors.error,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(l10n.absent),
            ],
          ),
        ),
        PopupMenuItem(
          value: AttendanceStatus.halfDay,
          child: Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(l10n.halfDay),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.edit_calendar_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.attendanceTitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
