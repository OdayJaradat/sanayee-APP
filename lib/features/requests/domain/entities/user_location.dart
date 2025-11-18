import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';


@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    DateTime? timestamp,
  }) = _UserLocation;

  const UserLocation._();

  
  Map<String, double> toMap() => {'latitude': latitude, 'longitude': longitude};
}
