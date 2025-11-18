import 'dart:math';

class DistanceCalculator {
  static double haversine({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLng = _degreesToRadians(lng2 - lng1);

    final lat1Rad = _degreesToRadians(lat1);
    final lat2Rad = _degreesToRadians(lat2);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        sin(dLng / 2) * sin(dLng / 2) * cos(lat1Rad) * cos(lat2Rad);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static Map<String, double>? parseLocation(String? location) {
    if (location == null) return null;

    final regex = RegExp(r'\((-?\d+\.?\d*),\s*(-?\d+\.?\d*)\)');
    final match = regex.firstMatch(location);

    if (match != null) {
      return {
        'lat': double.parse(match.group(1)!),
        'lng': double.parse(match.group(2)!),
      };
    }

    return null;
  }
}
