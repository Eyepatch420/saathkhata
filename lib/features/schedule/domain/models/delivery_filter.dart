import 'package:equatable/equatable.dart';
import '../../../../shared/models/schedule_model.dart';

/// Filter applied to a delivery list. [status] and [date] are sent to the
/// server (via [DeliveriesCubit.load]); [nameQuery] and the radius fields are
/// applied client-side over the already-loaded page since the API has no
/// name-search or geo-radius query params.
class DeliveryFilter extends Equatable {
  final DeliveryStatus? status;
  final DateTime? date;
  final String? nameQuery;
  final double? radiusKm;
  final double? centerLat;
  final double? centerLng;

  const DeliveryFilter({
    this.status,
    this.date,
    this.nameQuery,
    this.radiusKm,
    this.centerLat,
    this.centerLng,
  });

  bool get isEmpty =>
      status == null &&
      date == null &&
      (nameQuery == null || nameQuery!.isEmpty) &&
      radiusKm == null;

  int get activeCount => [
    status != null,
    date != null,
    nameQuery != null && nameQuery!.isNotEmpty,
    radiusKm != null,
  ].where((v) => v).length;

  DeliveryFilter copyWith({
    DeliveryStatus? status,
    bool clearStatus = false,
    DateTime? date,
    bool clearDate = false,
    String? nameQuery,
    bool clearName = false,
    double? radiusKm,
    double? centerLat,
    double? centerLng,
    bool clearRadius = false,
  }) => DeliveryFilter(
    status: clearStatus ? null : (status ?? this.status),
    date: clearDate ? null : (date ?? this.date),
    nameQuery: clearName ? null : (nameQuery ?? this.nameQuery),
    radiusKm: clearRadius ? null : (radiusKm ?? this.radiusKm),
    centerLat: clearRadius ? null : (centerLat ?? this.centerLat),
    centerLng: clearRadius ? null : (centerLng ?? this.centerLng),
  );

  @override
  List<Object?> get props => [
    status,
    date,
    nameQuery,
    radiusKm,
    centerLat,
    centerLng,
  ];
}
