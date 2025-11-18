import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../professionals/domain/entities/professional.dart';
import '../../../professionals/domain/repositories/professionals_repository.dart';

@injectable
class FindNearestProfessional {
  final ProfessionalsRepository _professionalsRepository;

  FindNearestProfessional(this._professionalsRepository);

  Future<Result<Professional>> call({
    required double latitude,
    required double longitude,
  }) async {
    final result = await _professionalsRepository.getAllProfessionals();

    return result.when(
      ok: (professionals) {
        final prosWithLocation = professionals
            .where((pro) => pro.hasLocation)
            .toList();

        if (prosWithLocation.isEmpty) {
          return Err(
            NotFoundFailure('لا يوجد صنايعيون متاحون في الوقت الحالي'),
          );
        }

        final proDistances = prosWithLocation.map((pro) {
          final distance = DistanceCalculator.haversine(
            lat1: latitude,
            lng1: longitude,
            lat2: pro.latitude!,
            lng2: pro.longitude!,
          );
          return MapEntry(pro, distance);
        }).toList()..sort((a, b) => a.value.compareTo(b.value));

        final nearest = proDistances.first.key;
        return Ok(nearest);
      },
      err: (failure) => Err(failure),
    );
  }

  Future<Result<List<Professional>>> findNearest({
    required double latitude,
    required double longitude,
    int limit = 5,
  }) async {
    final result = await _professionalsRepository.getAllProfessionals();

    return result.when(
      ok: (professionals) {
        final prosWithLocation = professionals
            .where((pro) => pro.hasLocation)
            .toList();

        if (prosWithLocation.isEmpty) {
          return Err(
            NotFoundFailure('لا يوجد صنايعيون متاحون في الوقت الحالي'),
          );
        }

        final proDistances = prosWithLocation.map((pro) {
          final distance = DistanceCalculator.haversine(
            lat1: latitude,
            lng1: longitude,
            lat2: pro.latitude!,
            lng2: pro.longitude!,
          );
          return MapEntry(pro, distance);
        }).toList()..sort((a, b) => a.value.compareTo(b.value));

        final nearest = proDistances
            .take(limit)
            .map((entry) => entry.key)
            .toList();

        return Ok(nearest);
      },
      err: (failure) => Err(failure),
    );
  }
}
