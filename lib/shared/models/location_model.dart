class LocationData {
  final double lat;
  final double lng;
  final String displayName;
  final String? houseNumber;
  final String? road;
  final String? suburb;
  final String? city;
  final String? state;
  final String? country;
  final String? postcode;

  const LocationData({
    required this.lat,
    required this.lng,
    required this.displayName,
    this.houseNumber,
    this.road,
    this.suburb,
    this.city,
    this.state,
    this.country,
    this.postcode,
  });

  factory LocationData.fromReverseJson(Map<String, dynamic> json) {
    final addr = (json['address'] as Map<String, dynamic>?) ?? {};
    return LocationData(
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lon'].toString()),
      displayName: json['display_name'] as String? ?? '',
      houseNumber: addr['house_number'] as String?,
      road: addr['road'] as String?,
      suburb: addr['suburb'] as String?,
      city: (addr['city'] ?? addr['town'] ?? addr['village']) as String?,
      state: addr['state'] as String?,
      country: addr['country'] as String?,
      postcode: addr['postcode'] as String?,
    );
  }

  LocationData copyWith({String? displayName}) => LocationData(
        lat: lat,
        lng: lng,
        displayName: displayName ?? this.displayName,
        houseNumber: houseNumber,
        road: road,
        suburb: suburb,
        city: city,
        state: state,
        country: country,
        postcode: postcode,
      );

  /// Short human-readable address line (road + city)
  String get shortAddress {
    final parts = <String?>[
      (houseNumber != null && road != null) ? '$houseNumber $road' : road,
      suburb,
      city,
    ].whereType<String>().toList();
    return parts.isNotEmpty ? parts.join(', ') : displayName;
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'displayName': displayName,
        'houseNumber': houseNumber,
        'road': road,
        'suburb': suburb,
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
      };
}

class LocationSuggestion {
  final double lat;
  final double lng;
  final String displayName;
  final String? type;
  final String? category;

  const LocationSuggestion({
    required this.lat,
    required this.lng,
    required this.displayName,
    this.type,
    this.category,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lon'].toString()),
      displayName: json['display_name'] as String? ?? '',
      type: json['type'] as String?,
      category: json['category'] as String?,
    );
  }
}
