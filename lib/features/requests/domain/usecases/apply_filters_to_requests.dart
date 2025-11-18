import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../entities/filter_criteria.dart';
import '../entities/service_request.dart';
import '../entities/sort_by.dart';

@injectable
class ApplyFiltersToRequests {
  List<ServiceRequest> call(
    List<ServiceRequest> requests,
    FilterCriteria criteria, {
    Position? currentPosition,
  }) {
    var filtered = List<ServiceRequest>.from(requests);

    if (criteria.categories.isNotEmpty) {
      filtered = filtered.where((request) {
        return criteria.categories.contains(request.category);
      }).toList();
    }

    if (criteria.budgetMin != null) {
      filtered = filtered.where((request) {
        return request.budget != null && request.budget! >= criteria.budgetMin!;
      }).toList();
    }

    if (criteria.budgetMax != null) {
      filtered = filtered.where((request) {
        return request.budget != null && request.budget! <= criteria.budgetMax!;
      }).toList();
    }

    if (criteria.distanceKm != null && currentPosition != null) {
      filtered = filtered.where((request) {
        if (request.location == null) {
          return true;
        }

        final locationData = DistanceCalculator.parseLocation(request.location);
        if (locationData == null) {
          return true;
        }

        final distance = DistanceCalculator.haversine(
          lat1: currentPosition.latitude,
          lng1: currentPosition.longitude,
          lat2: locationData['lat']!,
          lng2: locationData['lng']!,
        );

        return distance <= criteria.distanceKm!;
      }).toList();
    }

    filtered = _sortRequests(filtered, criteria.sortBy, currentPosition);

    return filtered;
  }

  List<ServiceRequest> _sortRequests(
    List<ServiceRequest> requests,
    SortBy sortBy,
    Position? currentPosition,
  ) {
    switch (sortBy) {
      case SortBy.dateDesc:
        requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case SortBy.budgetDesc:
        requests.sort((a, b) {
          final budgetA = a.budget ?? 0;
          final budgetB = b.budget ?? 0;
          return budgetB.compareTo(budgetA);
        });
        break;

      case SortBy.distanceAsc:
        if (currentPosition != null) {
          requests.sort((a, b) {
            final distanceA = _getDistance(a, currentPosition);
            final distanceB = _getDistance(b, currentPosition);
            return distanceA.compareTo(distanceB);
          });
        }
        break;
    }

    return requests;
  }

  double _getDistance(ServiceRequest request, Position position) {
    if (request.location == null) {
      return double.infinity;
    }

    final locationData = DistanceCalculator.parseLocation(request.location);
    if (locationData == null) {
      return double.infinity;
    }

    return DistanceCalculator.haversine(
      lat1: position.latitude,
      lng1: position.longitude,
      lat2: locationData['lat']!,
      lng2: locationData['lng']!,
    );
  }
}
