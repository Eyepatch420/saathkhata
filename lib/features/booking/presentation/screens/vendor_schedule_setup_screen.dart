import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _to12h(String hhmm) {
  final parts = hhmm.split(':');
  int h = int.parse(parts[0]);
  final m = parts[1];
  final period = h < 12 ? 'AM' : 'PM';
  if (h == 0) h = 12;
  if (h > 12) h -= 12;
  return '$h:$m $period';
}

/// Convert 12h TimeOfDay to 'HH:MM' 24h string
String _tod24(TimeOfDay tod) {
  final hh = tod.hour.toString().padLeft(2, '0');
  final mm = tod.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

/// Only an EXACT duplicate (startTime, endTime) pair is rejected now —
/// capacity slots are allowed to overlap in general (mirrors backend rule).
bool _hasExactDuplicate(List<DaySlot> slots) {
  final seen = <String>{};
  for (final s in slots) {
    final key = '${s.startTime}-${s.endTime}';
    if (!seen.add(key)) return true;
  }
  return false;
}

int _toMins(String hhmm) {
  final p = hhmm.split(':');
  return int.parse(p[0]) * 60 + int.parse(p[1]);
}

/// Contiguous-by-time check for merge eligibility, mirroring the backend
/// merge rule: sorted by startTime, each consecutive pair must touch or
/// overlap (next.startTime <= prev.endTime), no gap allowed.
bool _slotsContiguousForMerge(List<DaySlot> selected) {
  if (selected.length < 2) return false;
  final sorted = List<DaySlot>.from(selected)
    ..sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
  for (int i = 1; i < sorted.length; i++) {
    if (_toMins(sorted[i].startTime) > _toMins(sorted[i - 1].endTime)) return false;
  }
  return true;
}

const _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const _daysFull = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

// ─── Screen ───────────────────────────────────────────────────────────────────

class VendorScheduleSetupScreen extends StatelessWidget {
  const VendorScheduleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(getIt())..add(LoadBookingConfig()),
      child: const _ScheduleSetupView(),
    );
  }
}

class _ScheduleSetupView extends StatefulWidget {
  const _ScheduleSetupView();

  @override
  State<_ScheduleSetupView> createState() => _ScheduleSetupViewState();
}

enum _ScreenMode { weekly, calendar }

class _ScheduleSetupViewState extends State<_ScheduleSetupView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Local mutable copy of the config being edited
  BookingConfig _config = BookingConfig.empty();
  bool _hasLoaded = false;
  _ScreenMode _mode = _ScreenMode.weekly;
  DateTime _calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);
  // date ('YYYY-MM-DD') -> override info, populated as dates are viewed/edited
  final Map<String, DateSlotOverride> _dateOverrideCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyConfig(BookingConfig config) {
    if (!_hasLoaded) {
      setState(() {
        _config = config;
        _hasLoaded = true;
      });
    }
  }

  void _addSlot(int day) async {
    final result = await showDialog<DaySlot>(
      context: context,
      builder: (_) => _AddSlotDialog(existingSlots: _config.slotsForDay(day)),
    );
    if (result == null) return;
    final updated = List<DaySlot>.from(_config.slotsForDay(day))..add(result);
    updated.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    setState(() => _config = _config.withUpdatedDay(day, updated));
  }

  void _editSlot(int day, int slotIndex) async {
    final existing = _config.slotsForDay(day)[slotIndex];
    final others = List<DaySlot>.from(_config.slotsForDay(day))..removeAt(slotIndex);
    final result = await showDialog<DaySlot>(
      context: context,
      builder: (_) => _AddSlotDialog(
        existingSlots: others,
        initial: existing,
      ),
    );
    if (result == null) return;
    final updated = List<DaySlot>.from(_config.slotsForDay(day));
    updated[slotIndex] = result;
    updated.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    setState(() => _config = _config.withUpdatedDay(day, updated));
  }

  void _deleteSlot(int day, int slotIndex) {
    final updated = List<DaySlot>.from(_config.slotsForDay(day))..removeAt(slotIndex);
    setState(() => _config = _config.withUpdatedDay(day, updated));
  }

  void _toggleEnabled(int day, int slotIndex, bool value) {
    final updated = List<DaySlot>.from(_config.slotsForDay(day));
    updated[slotIndex] = updated[slotIndex].copyWith(isEnabled: value);
    setState(() => _config = _config.withUpdatedDay(day, updated));
  }

  void _toggleFull(int day, int slotIndex, bool value) {
    final updated = List<DaySlot>.from(_config.slotsForDay(day));
    updated[slotIndex] = updated[slotIndex].copyWith(isFull: value);
    setState(() => _config = _config.withUpdatedDay(day, updated));
    // Also persist toggle to backend immediately
    context.read<BookingBloc>().add(ToggleSlotFull(
          dayOfWeek: day,
          startTime: updated[slotIndex].startTime,
          isFull: value,
        ));
  }

  void _save() {
    context.read<BookingBloc>().add(SaveBookingConfig(_config));
  }

  void _mergeWeeklySlots(int day, List<int> slotIndexes, int mergedCapacity) {
    final daySlots = _config.slotsForDay(day);
    final sortedIndexes = List<int>.from(slotIndexes)..sort();
    final selected = sortedIndexes.map((i) => daySlots[i]).toList()
      ..sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    final merged = DaySlot(
      startTime: selected.first.startTime,
      endTime: selected.map((s) => s.endTime).reduce((a, b) => _toMins(a) > _toMins(b) ? a : b),
      maxCapacity: mergedCapacity,
    );
    final remaining = <DaySlot>[
      for (int i = 0; i < daySlots.length; i++)
        if (!sortedIndexes.contains(i)) daySlots[i], merged,
    ];
    remaining.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    // Purely local — like add/edit/delete, this only takes effect once the
    // vendor hits Save. A separate index-based backend call here would be
    // unsafe: the indexes are computed against this in-memory (possibly
    // unsaved) list, not whatever is currently persisted server-side.
    setState(() => _config = _config.withUpdatedDay(day, remaining));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingConfigLoaded) {
          _applyConfig(state.config);
        } else if (state is BookingConfigSaved) {
          _applyConfig(state.config);
          AppToast.show(context, AppLocalizations.of(context)!.scheduleSaved, type: ToastType.success);
          if (context.mounted) context.pop();
        } else if (state is BookingConfigError) {
          AppToast.show(context, state.message, type: ToastType.error);
          if (state.config != null) _applyConfig(state.config!);
        }
      },
      builder: (context, state) {
        final isLoading = state is BookingConfigLoading;
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.manageSchedule, style: AppTypography.h3),
            bottom: _mode == _ScreenMode.weekly
                ? TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
                    indicatorColor: AppColors.primary,
                    tabs: List.generate(
                      7,
                      (i) => Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_days[i], style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(
                                color: _config.slotsForDay(i).isNotEmpty
                                    ? AppColors.primary
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : PreferredSize(
                    preferredSize: const Size.fromHeight(52),
                    child: _ModeToggleBar(mode: _mode, onChanged: _setMode),
                  ),
            actions: [
              if (_mode == _ScreenMode.weekly)
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  TextButton(
                    onPressed: _save,
                    child: Text(
                      l10n.save,
                      style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                    ),
                  ),
            ],
          ),
          body: Column(
            children: [
              if (_mode == _ScreenMode.weekly)
                _ModeToggleBar(mode: _mode, onChanged: _setMode),
              Expanded(
                child: _mode == _ScreenMode.weekly
                    ? TabBarView(
                        controller: _tabController,
                        children: List.generate(7, (day) => _DayTab(
                          day: day,
                          slots: _config.slotsForDay(day),
                          onAdd: () => _addSlot(day),
                          onEdit: (i) => _editSlot(day, i),
                          onDelete: (i) => _deleteSlot(day, i),
                          onToggleEnabled: (i, v) => _toggleEnabled(day, i, v),
                          onToggleFull: (i, v) => _toggleFull(day, i, v),
                          onMerge: (indexes, cap) => _mergeWeeklySlots(day, indexes, cap),
                        )),
                      )
                    : _CalendarView(
                        month: _calendarMonth,
                        onMonthChanged: (m) => setState(() => _calendarMonth = m),
                        overrideCache: _dateOverrideCache,
                        onDayTapped: _openDaySheet,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setMode(_ScreenMode mode) => setState(() => _mode = mode);

  Future<void> _openDaySheet(DateTime date) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingBloc>(),
        child: _DateSlotSheet(
          date: date,
          onOverrideChanged: (override) {
            setState(() => _dateOverrideCache[override.date] = override);
          },
        ),
      ),
    );
  }
}

String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// ─── Mode toggle bar ──────────────────────────────────────────────────────────

class _ModeToggleBar extends StatelessWidget {
  final _ScreenMode mode;
  final ValueChanged<_ScreenMode> onChanged;

  const _ModeToggleBar({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SegmentedButton<_ScreenMode>(
        segments: [
          ButtonSegment(value: _ScreenMode.weekly, label: Text(l10n.weeklyTemplateTab)),
          ButtonSegment(value: _ScreenMode.calendar, label: Text(l10n.calendarTab)),
        ],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.primary,
          selectedForegroundColor: Colors.white,
        ),
      ),
    );
  }
}

// ─── Day Tab ──────────────────────────────────────────────────────────────────

class _DayTab extends StatefulWidget {
  final int day;
  final List<DaySlot> slots;
  final VoidCallback onAdd;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final void Function(int, bool) onToggleEnabled;
  final void Function(int, bool) onToggleFull;
  final void Function(List<int> slotIndexes, int mergedCapacity) onMerge;

  const _DayTab({
    required this.day,
    required this.slots,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleEnabled,
    required this.onToggleFull,
    required this.onMerge,
  });

  @override
  State<_DayTab> createState() => _DayTabState();
}

class _DayTabState extends State<_DayTab> {
  bool _selectMode = false;
  final Set<int> _selected = {};

  @override
  void didUpdateWidget(covariant _DayTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day) {
      _selectMode = false;
      _selected.clear();
    }
  }

  void _toggleSelectMode() {
    setState(() {
      _selectMode = !_selectMode;
      _selected.clear();
    });
  }

  void _toggleSelected(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  Future<void> _confirmMerge() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedSlots = _selected.map((i) => widget.slots[i]).toList();
    if (!_slotsContiguousForMerge(selectedSlots)) {
      AppToast.show(context, l10n.mergeNotContiguousHint, type: ToastType.error);
      return;
    }
    final result = await _showMergeConfirmDialog(context, selectedSlots);
    if (result == null || !mounted) return;
    widget.onMerge(_selected.toList(), result);
    setState(() {
      _selectMode = false;
      _selected.clear();
    });
    AppToast.show(context, l10n.mergeSucceededToast, type: ToastType.success);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final selectedSlots = _selected.map((i) => widget.slots[i]).toList();
    final canMerge = _selectMode && _slotsContiguousForMerge(selectedSlots);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _daysFull[widget.day],
                    style: AppTypography.h3,
                  ),
                ),
                if (widget.slots.length >= 2)
                  IconButton(
                    onPressed: _toggleSelectMode,
                    icon: Icon(_selectMode ? Icons.close_rounded : Icons.checklist_rounded),
                    color: AppColors.primary,
                    tooltip: _selectMode ? l10n.cancelSelectButton : l10n.selectModeButton,
                  ),
                if (!_selectMode)
                  TextButton.icon(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: Text(l10n.addSlot),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  ),
              ],
            ),
          ),
        ),
        if (_selectMode)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selected.length < 2 ? l10n.mergeNotContiguousHint : (canMerge ? '' : l10n.mergeNotContiguousHint),
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selected.length >= 2 ? _confirmMerge : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text(l10n.mergeSlotsButton, style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        if (widget.slots.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 48,
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noSlotsForDay(_daysFull[widget.day]),
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.tapAddSlotHint,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _SlotCard(
                  slot: widget.slots[i],
                  index: i,
                  onEdit: () => widget.onEdit(i),
                  onDelete: () => widget.onDelete(i),
                  onToggleEnabled: (v) => widget.onToggleEnabled(i, v),
                  onToggleFull: (v) => widget.onToggleFull(i, v),
                  selectMode: _selectMode,
                  selected: _selected.contains(i),
                  onSelectToggle: () => _toggleSelected(i),
                ),
                childCount: widget.slots.length,
              ),
            ),
          ),
      ],
    );
  }
}

/// Shows a confirm dialog with the computed merged time range and an
/// editable capacity field (default = sum of selected slots' capacities).
/// Returns the chosen mergedCapacity, or null if cancelled.
Future<int?> _showMergeConfirmDialog(BuildContext context, List<DaySlot> selectedSlots) {
  final sorted = List<DaySlot>.from(selectedSlots)
    ..sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
  final start = sorted.first.startTime;
  final end = sorted.map((s) => s.endTime).reduce((a, b) => _toMins(a) > _toMins(b) ? a : b);
  final defaultCapacity = selectedSlots.fold<int>(0, (sum, s) => sum + s.maxCapacity);
  final controller = TextEditingController(text: '$defaultCapacity');
  final l10n = AppLocalizations.of(context)!;

  return showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.confirmMergeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.confirmMergeMessage(_to12h(start), _to12h(end))),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.mergedCapacityLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            final cap = int.tryParse(controller.text) ?? defaultCapacity;
            Navigator.pop(ctx, cap < 1 ? 1 : cap);
          },
          child: Text(l10n.mergeSlotsButton),
        ),
      ],
    ),
  );
}

// ─── Slot Card ────────────────────────────────────────────────────────────────

class _SlotCard extends StatelessWidget {
  final DaySlot slot;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleEnabled;
  final ValueChanged<bool> onToggleFull;
  final bool selectMode;
  final bool selected;
  final VoidCallback? onSelectToggle;

  const _SlotCard({
    required this.slot,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleEnabled,
    required this.onToggleFull,
    this.selectMode = false,
    this.selected = false,
    this.onSelectToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = !slot.isEnabled;
    final cardColor = isDisabled
        ? colorScheme.surface.withValues(alpha: 0.5)
        : colorScheme.surface;

    return InkWell(
      onTap: selectMode ? onSelectToggle : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : slot.isFull
                  ? AppColors.warning.withValues(alpha: 0.5)
                  : isDisabled
                      ? colorScheme.outline.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.15),
          width: selected ? 2 : 1.5,
        ),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        children: [
          // ── Header row ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                if (selectMode)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Checkbox(
                      value: selected,
                      onChanged: (_) => onSelectToggle?.call(),
                      activeColor: AppColors.primary,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDisabled
                          ? colorScheme.outline.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDisabled ? colorScheme.outline : AppColors.primary,
                    ),
                  ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_to12h(slot.startTime)} – ${_to12h(slot.endTime)}',
                      style: AppTypography.labelLarge.copyWith(
                        color: isDisabled
                            ? colorScheme.onSurface.withValues(alpha: 0.4)
                            : colorScheme.onSurface,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Row(
                      children: [
                        if (slot.isFull)
                          Padding(
                            padding: const EdgeInsets.only(top: 2, right: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'SLOTS FULL',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 10,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        if (slot.maxCapacity > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${AppLocalizations.of(context)!.capacityLabel}: ${slot.maxCapacity}',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (!selectMode) ...[
                  // Edit
                  IconButton(
                    onPressed: isDisabled ? null : onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: isDisabled
                          ? colorScheme.outline.withValues(alpha: 0.3)
                          : AppColors.primary,
                    ),
                    tooltip: AppLocalizations.of(context)!.editTimeSlot,
                  ),
                  // Delete
                  IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.error.withValues(alpha: isDisabled ? 0.4 : 1),
                    ),
                    tooltip: AppLocalizations.of(context)!.deleteSlotTitle,
                  ),
                ],
              ],
            ),
          ),
          // ── Toggle row ──────────────────────────────────────────────────────
          if (!selectMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  // Available toggle
                  Expanded(
                    child: _ToggleRow(
                      label: AppLocalizations.of(context)!.slotAvailable,
                      value: slot.isEnabled,
                      activeColor: AppColors.success,
                      onChanged: onToggleEnabled,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Slot Full toggle
                  Expanded(
                    child: _ToggleRow(
                      label: AppLocalizations.of(context)!.slotsFull,
                      value: slot.isFull,
                      activeColor: AppColors.warning,
                      onChanged: slot.isEnabled ? onToggleFull : null,
                      tooltip: slot.isEnabled
                          ? AppLocalizations.of(context)!.slotFullHint
                          : AppLocalizations.of(context)!.enableSlotFirst,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSlotTitle),
        content: Text(
          l10n.deleteSlotConfirm('${_to12h(slot.startTime)} – ${_to12h(slot.endTime)}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.keepButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool>? onChanged;
  final String? tooltip;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onChanged != null;
    return Tooltip(
      message: tooltip ?? '',
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: activeColor,
            activeTrackColor: activeColor.withValues(alpha: 0.4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: enabled
                  ? colorScheme.onSurface.withValues(alpha: 0.7)
                  : colorScheme.onSurface.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit Slot Dialog ───────────────────────────────────────────────────

class _AddSlotDialog extends StatefulWidget {
  final List<DaySlot> existingSlots;
  final DaySlot? initial;

  const _AddSlotDialog({required this.existingSlots, this.initial});

  @override
  State<_AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<_AddSlotDialog> {
  late TimeOfDay _start;
  late TimeOfDay _end;
  late int _capacity;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      final sp = widget.initial!.startTime.split(':');
      final ep = widget.initial!.endTime.split(':');
      _start = TimeOfDay(hour: int.parse(sp[0]), minute: int.parse(sp[1]));
      _end = TimeOfDay(hour: int.parse(ep[0]), minute: int.parse(ep[1]));
      _capacity = widget.initial!.maxCapacity;
    } else {
      _start = const TimeOfDay(hour: 9, minute: 0);
      _end = const TimeOfDay(hour: 10, minute: 0);
      _capacity = 1;
    }
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _start,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _end,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _end = picked);
  }

  void _confirm() {
    final startStr = _tod24(_start);
    final endStr = _tod24(_end);

    final l10n = AppLocalizations.of(context)!;
    if (_toMins(endStr) <= _toMins(startStr)) {
      setState(() => _error = l10n.endTimeAfterStart);
      return;
    }

    // General time-overlap between distinct slots is allowed (capacity
    // slots may legitimately span overlapping windows). Only an EXACT
    // duplicate (startTime, endTime) pair is rejected.
    final candidate = DaySlot(
      startTime: startStr,
      endTime: endStr,
      maxCapacity: _capacity,
    );
    final testList = [...widget.existingSlots, candidate];
    if (_hasExactDuplicate(testList)) {
      setState(() => _error = l10n.duplicateSlotExists);
      return;
    }

    Navigator.pop(context, candidate);
  }

  void _incrementCapacity() {
    if (_capacity < 20) setState(() => _capacity++);
  }

  void _decrementCapacity() {
    if (_capacity > 1) setState(() => _capacity--);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.initial != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? l10n.editTimeSlot : l10n.addTimeSlot,
              style: AppTypography.h3,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.selectTimeHint,
              style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _TimePickerButton(
                    label: l10n.startLabel,
                    time: _start,
                    onTap: _pickStart,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '–',
                    style: AppTypography.h3.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Expanded(
                  child: _TimePickerButton(
                    label: l10n.endLabel,
                    time: _end,
                    onTap: _pickEnd,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  l10n.capacityLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                _CapacityStepper(
                  value: _capacity,
                  onDecrement: _decrementCapacity,
                  onIncrement: _incrementCapacity,
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.error),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _error!,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEdit ? l10n.update : l10n.add,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Capacity Stepper ─────────────────────────────────────────────────────────

class _CapacityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CapacityStepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? onDecrement : null,
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: AppColors.primary,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge,
            ),
          ),
          IconButton(
            onPressed: value < 20 ? onIncrement : null,
            icon: const Icon(Icons.add_rounded, size: 18),
            color: AppColors.primary,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _TimePickerButton extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimePickerButton({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = time.format(context); // system locale 12h
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatted,
                    style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                  ),
                ),
                Icon(Icons.schedule_rounded, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Calendar mode: month grid ────────────────────────────────────────────────

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class _CalendarView extends StatelessWidget {
  final DateTime month; // any date within the displayed month
  final ValueChanged<DateTime> onMonthChanged;
  final Map<String, DateSlotOverride> overrideCache;
  final ValueChanged<DateTime> onDayTapped;

  const _CalendarView({
    required this.month,
    required this.onMonthChanged,
    required this.overrideCache,
    required this.onDayTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // firstOfMonth.weekday: Mon=1..Sun=7; we want Sun=0..Sat=6 leading blanks
    final leadingBlanks = firstOfMonth.weekday % 7;
    final today = DateTime.now();
    final todayKey = _dateKey(DateTime(today.year, today.month, today.day));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => onMonthChanged(DateTime(month.year, month.month - 1)),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[month.month - 1]} ${month.year}',
                  textAlign: TextAlign.center,
                  style: AppTypography.h3,
                ),
              ),
              IconButton(
                onPressed: () => onMonthChanged(DateTime(month.year, month.month + 1)),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _days
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, i) {
              if (i < leadingBlanks) return const SizedBox.shrink();
              final dayNum = i - leadingBlanks + 1;
              final date = DateTime(month.year, month.month, dayNum);
              final key = _dateKey(date);
              final override = overrideCache[key];
              final isToday = key == todayKey;
              return _CalendarDayCell(
                dayNum: dayNum,
                isToday: isToday,
                hasOverride: override?.isOverride ?? false,
                isClosed: override?.closed ?? false,
                onTap: () => onDayTapped(date),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final int dayNum;
  final bool isToday;
  final bool hasOverride;
  final bool isClosed;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.dayNum,
    required this.isToday,
    required this.hasOverride,
    required this.isClosed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
          color: isClosed
              ? AppColors.error.withValues(alpha: 0.08)
              : hasOverride
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$dayNum',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
            if (isClosed)
              Positioned(
                bottom: 4,
                child: Icon(Icons.block_rounded, size: 10, color: AppColors.error.withValues(alpha: 0.8)),
              )
            else if (hasOverride)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Date Slot Sheet (Calendar mode day editor) ───────────────────────────────

class _DateSlotSheet extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateSlotOverride> onOverrideChanged;

  const _DateSlotSheet({required this.date, required this.onOverrideChanged});

  @override
  State<_DateSlotSheet> createState() => _DateSlotSheetState();
}

class _DateSlotSheetState extends State<_DateSlotSheet> {
  List<DaySlot> _slots = [];
  bool _isOverride = false;
  bool _closed = false;
  bool _hasLoaded = false;
  bool _selectMode = false;
  final Set<int> _selected = {};

  String get _dateStr => _dateKey(widget.date);

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadDateSlots(_dateStr));
  }

  void _applyOverride(DateSlotOverride override) {
    setState(() {
      _slots = List<DaySlot>.from(override.slots);
      _isOverride = override.isOverride;
      _closed = override.closed;
      _hasLoaded = true;
    });
    widget.onOverrideChanged(override);
  }

  void _addSlot() async {
    final result = await showDialog<DaySlot>(
      context: context,
      builder: (_) => _AddSlotDialog(existingSlots: _slots),
    );
    if (result == null) return;
    final updated = List<DaySlot>.from(_slots)..add(result);
    updated.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    setState(() => _slots = updated);
  }

  void _editSlot(int index) async {
    final existing = _slots[index];
    final others = List<DaySlot>.from(_slots)..removeAt(index);
    final result = await showDialog<DaySlot>(
      context: context,
      builder: (_) => _AddSlotDialog(existingSlots: others, initial: existing),
    );
    if (result == null) return;
    final updated = List<DaySlot>.from(_slots);
    updated[index] = result;
    updated.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    setState(() => _slots = updated);
  }

  void _deleteSlot(int index) {
    final updated = List<DaySlot>.from(_slots)..removeAt(index);
    setState(() => _slots = updated);
  }

  void _toggleEnabled(int index, bool value) {
    final updated = List<DaySlot>.from(_slots);
    updated[index] = updated[index].copyWith(isEnabled: value);
    setState(() => _slots = updated);
  }

  void _toggleFull(int index, bool value) {
    final updated = List<DaySlot>.from(_slots);
    updated[index] = updated[index].copyWith(isFull: value);
    setState(() => _slots = updated);
  }

  void _save() {
    context.read<BookingBloc>().add(SaveDateSlots(_dateStr, _slots));
  }

  void _toggleClosed(bool value) {
    context.read<BookingBloc>().add(SetDateClosed(_dateStr, value));
  }

  void _revertToTemplate() {
    context.read<BookingBloc>().add(DeleteDateSlots(_dateStr));
  }

  void _toggleSelectMode() {
    setState(() {
      _selectMode = !_selectMode;
      _selected.clear();
    });
  }

  void _toggleSelected(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  Future<void> _confirmMerge() async {
    final l10n = AppLocalizations.of(context)!;
    final sortedIndexes = List<int>.from(_selected)..sort();
    final selected = sortedIndexes.map((i) => _slots[i]).toList()
      ..sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    if (!_slotsContiguousForMerge(selected)) {
      AppToast.show(context, l10n.mergeNotContiguousHint, type: ToastType.error);
      return;
    }
    final mergedCapacity = await _showMergeConfirmDialog(context, selected);
    if (mergedCapacity == null || !mounted) return;
    final merged = DaySlot(
      startTime: selected.first.startTime,
      endTime: selected
          .map((s) => s.endTime)
          .reduce((a, b) => _toMins(a) > _toMins(b) ? a : b),
      maxCapacity: mergedCapacity,
    );
    final remaining = <DaySlot>[
      for (int i = 0; i < _slots.length; i++)
        if (!sortedIndexes.contains(i)) _slots[i], merged,
    ];
    remaining.sort((a, b) => _toMins(a.startTime).compareTo(_toMins(b.startTime)));
    // Purely local — like add/edit/delete on this sheet, this only takes
    // effect once the vendor hits Save. Sending index-based merge straight
    // to the backend here would be unsafe: the indexes are computed against
    // this in-memory (possibly unsaved) list, not whatever is currently
    // persisted server-side for this date.
    setState(() {
      _slots = remaining;
      _selectMode = false;
      _selected.clear();
    });
    if (mounted) AppToast.show(context, l10n.mergeSucceededToast, type: ToastType.success);
  }

  void _openReplicateDialog() async {
    final bloc = context.read<BookingBloc>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _ReplicateSheet(sourceDate: _dateStr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is DateSlotsLoaded && state.dateSlots.date == _dateStr) {
          _applyOverride(state.dateSlots);
        } else if (state is DateSlotsSaved && state.dateSlots.date == _dateStr) {
          _applyOverride(state.dateSlots);
          AppToast.show(
            context,
            state.dateSlots.isOverride
                ? l10n.dateSavedToast
                : (state.dateSlots.closed ? l10n.dateClosedToast : l10n.revertedToTemplateToast),
            type: ToastType.success,
          );
        } else if (state is DateSlotsError) {
          AppToast.show(context, state.message, type: ToastType.error);
        } else if (state is ReplicateCompleted) {
          AppToast.show(
            context,
            l10n.replicateResultToast(
              state.result.appliedDates.length,
              state.result.skippedDates.length,
              state.result.failedDates.length,
            ),
            type: ToastType.success,
          );
        } else if (state is ReplicateError) {
          AppToast.show(context, state.message, type: ToastType.error);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.9),
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
          child: !_hasLoaded
              ? const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, mq.viewPadding.bottom + 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat.yMMMMd().format(widget.date),
                              style: AppTypography.h3,
                            ),
                          ),
                          TextButton(
                            onPressed: _save,
                            child: Text(l10n.save),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _StatusBadge(isOverride: _isOverride, closed: _closed),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(l10n.markAsClosed, style: AppTypography.labelLarge),
                          ),
                          Switch(
                            value: _closed,
                            onChanged: (v) => _toggleClosed(v),
                            activeThumbColor: AppColors.error,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (_isOverride)
                            TextButton.icon(
                              onPressed: _revertToTemplate,
                              icon: const Icon(Icons.restore_rounded, size: 18),
                              label: Text(l10n.revertToTemplate),
                            ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _openReplicateDialog,
                            icon: const Icon(Icons.copy_all_rounded, size: 18),
                            label: Text(l10n.replicateToButton),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      if (!_closed) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.addSlot,
                                style: AppTypography.h3.copyWith(fontSize: 16),
                              ),
                            ),
                            if (_slots.length >= 2)
                              IconButton(
                                onPressed: _toggleSelectMode,
                                icon: Icon(_selectMode ? Icons.close_rounded : Icons.checklist_rounded),
                                color: AppColors.primary,
                                tooltip: _selectMode ? l10n.cancelSelectButton : l10n.selectModeButton,
                              ),
                            if (!_selectMode)
                              TextButton.icon(
                                onPressed: _addSlot,
                                icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                                label: Text(l10n.addSlot),
                                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                              ),
                          ],
                        ),
                        if (_selectMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.mergeNotContiguousHint,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _selected.length >= 2 ? _confirmMerge : null,
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  child: Text(l10n.mergeSlotsButton, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        if (_slots.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                l10n.tapAddSlotHint,
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          )
                        else
                          ...List.generate(
                            _slots.length,
                            (i) => _SlotCard(
                              slot: _slots[i],
                              index: i,
                              onEdit: () => _editSlot(i),
                              onDelete: () => _deleteSlot(i),
                              onToggleEnabled: (v) => _toggleEnabled(i, v),
                              onToggleFull: (v) => _toggleFull(i, v),
                              selectMode: _selectMode,
                              selected: _selected.contains(i),
                              onSelectToggle: () => _toggleSelected(i),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOverride;
  final bool closed;

  const _StatusBadge({required this.isOverride, required this.closed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String label;
    final Color color;
    if (closed) {
      label = l10n.closedBadge;
      color = AppColors.error;
    } else if (isOverride) {
      label = l10n.customForThisDate;
      color = AppColors.primary;
    } else {
      label = l10n.usingWeeklyTemplate;
      color = AppColors.textHint;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ─── Replicate sheet ──────────────────────────────────────────────────────────

enum _ReplicateTarget { week, month, months }

class _ReplicateSheet extends StatefulWidget {
  final String sourceDate;
  const _ReplicateSheet({required this.sourceDate});

  @override
  State<_ReplicateSheet> createState() => _ReplicateSheetState();
}

class _ReplicateSheetState extends State<_ReplicateSheet> {
  _ReplicateTarget _target = _ReplicateTarget.week;
  late DateTime _startDate;
  int _monthsCount = 2;

  @override
  void initState() {
    super.initState();
    final parts = widget.sourceDate.split('-');
    _startDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  void _apply() {
    final targetType = switch (_target) {
      _ReplicateTarget.week => 'week',
      _ReplicateTarget.month => 'month',
      _ReplicateTarget.months => 'months',
    };
    context.read<BookingBloc>().add(ReplicateSlots(
          sourceDate: widget.sourceDate,
          targetType: targetType,
          startDate: _dateKey(_startDate),
          monthsCount: _target == _ReplicateTarget.months ? _monthsCount : null,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, mq.viewPadding.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(l10n.replicateToButton, style: AppTypography.h3),
              const SizedBox(height: 16),
              SegmentedButton<_ReplicateTarget>(
                segments: [
                  ButtonSegment(value: _ReplicateTarget.week, label: Text(l10n.replicateTargetWeek)),
                  ButtonSegment(value: _ReplicateTarget.month, label: Text(l10n.replicateTargetMonth)),
                  ButtonSegment(value: _ReplicateTarget.months, label: Text(l10n.replicateTargetMultipleMonths)),
                ],
                selected: {_target},
                onSelectionChanged: (s) => setState(() => _target = s.first),
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.primary,
                  selectedForegroundColor: Colors.white,
                ),
              ),
              if (_target == _ReplicateTarget.months) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text(l10n.replicateMonthsCount, style: AppTypography.bodyMedium)),
                    _CapacityStepper(
                      value: _monthsCount,
                      onDecrement: () {
                        if (_monthsCount > 2) setState(() => _monthsCount--);
                      },
                      onIncrement: () {
                        if (_monthsCount < 12) setState(() => _monthsCount++);
                      },
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Text(l10n.replicateStartDateLabel, style: AppTypography.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              )),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: _pickStartDate,
                child: Text(DateFormat.yMMMMd().format(_startDate)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    l10n.applyReplicateButton,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
