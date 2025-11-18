import 'package:freezed_annotation/freezed_annotation.dart';

part 'professional.freezed.dart';

@freezed
class Professional with _$Professional {
  const factory Professional({
    required String id,
    required String name,
    String? avatarUrl,
    required List<String> skills,
    required double rating,
    required int jobsCount,
    String? bio,
    double? latitude,
    double? longitude,
  }) = _Professional;

  const Professional._();

  
  bool get hasLocation => latitude != null && longitude != null;

  
  Map<String, double>? get locationMap {
    if (!hasLocation) return null;
    return {'latitude': latitude!, 'longitude': longitude!};
  }
}
