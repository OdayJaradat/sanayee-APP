import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/user_location.dart';

@injectable
class GetCurrentPosition {
  GetCurrentPosition();

  
  
  
  
  
  
  Future<Result<UserLocation>> call() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Err(
          ValidationFailure(
            'خدمات الموقع غير مفعلة. يرجى تفعيلها من الإعدادات',
          ),
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Err(ValidationFailure('تم رفض إذن الوصول للموقع'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Err(
          ValidationFailure(
            'تم رفض إذن الوصول للموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return Ok(
        UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          timestamp: position.timestamp,
        ),
      );
    } catch (e) {
      return Err(ServerFailure('فشل الحصول على الموقع: ${e.toString()}'));
    }
  }

  
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}
