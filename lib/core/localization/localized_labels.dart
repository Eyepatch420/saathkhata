import '../../l10n/app_localizations.dart';
import '../../shared/models/ledger_entry.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/schedule_model.dart';

/// Maps domain enums and derived model labels to their localized display text.
///
/// Models keep their plain-English `label` getters for logging and JSON, but
/// every widget renders these localized variants instead.
extension LocalizedLabels on AppLocalizations {
  String serviceTypeName(ServiceType type) => switch (type) {
        ServiceType.product => serviceTypeProduct,
        ServiceType.session => serviceTypeSession,
      };

  String scheduleTypeName(ScheduleType type) => switch (type) {
        ScheduleType.daily => scheduleTypeDaily,
        ScheduleType.weekly => scheduleTypeWeekly,
        ScheduleType.customDays => scheduleTypeCustomDays,
      };

  String deliveryStatusName(DeliveryStatus status) => switch (status) {
        DeliveryStatus.scheduled => deliveryStatusScheduled,
        DeliveryStatus.delivered => deliveryStatusDelivered,
        DeliveryStatus.skipped => deliveryStatusSkipped,
        DeliveryStatus.failed => deliveryStatusFailed,
      };

  String orderStatusName(OrderStatus status) => switch (status) {
        OrderStatus.pending => orderStatusPending,
        OrderStatus.confirmed => orderStatusConfirmed,
        OrderStatus.rejected => orderStatusRejected,
        OrderStatus.delivered => orderStatusDelivered,
        OrderStatus.cancelled => orderStatusCancelled,
      };

  String entryStatusName(EntryStatus status) => switch (status) {
        EntryStatus.pending => statusPending,
        EntryStatus.confirmed => statusConfirmed,
        EntryStatus.disputed => statusDisputed,
        EntryStatus.autoConfirmed => statusAutoConfirmed,
      };

  String entryTypeName(EntryType type) => switch (type) {
        EntryType.credit => creditLabel,
        EntryType.payment => paymentLabel,
        EntryType.advance => advanceSingle,
        EntryType.adjustment => entryTypeAdjustmentLabel,
      };

  /// Localized display name for a stored business-category value. The stored
  /// value itself stays in English (it is sent to / read from the API).
  String businessCategoryName(String raw) => switch (raw) {
        'Milk / Dairy' => businessCategoryMilkDairy,
        'Press / Dhobi' => businessCategoryPressDhobi,
        'Maid / Cook' => businessCategoryMaidCook,
        'Newspaper' => businessCategoryNewspaper,
        'Water Can' => businessCategoryWaterCan,
        'Tiffin / Food' => businessCategoryTiffinFood,
        'Kirana / Grocery' => businessCategoryKiranaGrocery,
        'Salon / Parlour' => businessCategorySalonParlour,
        'Construction Labour' => businessCategoryConstructionLabour,
        'Transport / Auto' => businessCategoryTransportAuto,
        'Gym / Fitness' => businessCategoryGymFitness,
        'Other' => businessCategoryOther,
        _ => raw,
      };

  /// Localized short weekday name for an intl weekday index (Sunday = 0).
  String weekdayShort(int weekday) => switch (weekday % 7) {
        0 => weekdayShortSun,
        1 => weekdayShortMon,
        2 => weekdayShortTue,
        3 => weekdayShortWed,
        4 => weekdayShortThu,
        5 => weekdayShortFri,
        _ => weekdayShortSat,
      };

  /// Localized equivalent of [ScheduledService.scheduleLabel], e.g.
  /// "Daily" or "Mon, Wed, Fri".
  String serviceScheduleName(ScheduledService service) {
    final days = service.deliveryDays;
    switch (service.scheduleType) {
      case ScheduleType.daily:
        return scheduleTypeDaily;
      case ScheduleType.weekly:
        if (days != null && days.isNotEmpty) {
          return days.map(weekdayShort).join(', ');
        }
        return scheduleTypeWeekly;
      case ScheduleType.customDays:
        if (days != null && days.isNotEmpty) {
          return days.map(weekdayShort).join(', ');
        }
        return scheduleTypeCustom;
    }
  }
}
