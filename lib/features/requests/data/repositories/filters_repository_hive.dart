import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/repositories/filters_repository.dart';

@LazySingleton(as: FiltersRepository)
class FiltersRepositoryHive implements FiltersRepository {
  static const String _boxName = 'prefs';
  static const String _clientKey = 'filters.client';
  static const String _proKey = 'filters.pro';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  String _getKeyForRole(String role) {
    return role == 'pro' ? _proKey : _clientKey;
  }

  @override
  Future<Result<FilterCriteria>> loadFilters(String role) async {
    try {
      final box = await _getBox();
      final key = _getKeyForRole(role);
      final jsonData = box.get(key) as Map?;

      if (jsonData == null) {
        return Ok(FilterCriteria.defaultCriteria());
      }

      final data = Map<String, dynamic>.from(jsonData);
      final criteria = FilterCriteria.fromJson(data);

      return Ok(criteria);
    } catch (e) {
      return Err(CacheFailure('فشل في تحميل الفلاتر: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> saveFilters(String role, FilterCriteria criteria) async {
    try {
      final box = await _getBox();
      final key = _getKeyForRole(role);
      final jsonData = criteria.toJson();

      await box.put(key, jsonData);

      return const Ok(null);
    } catch (e) {
      return Err(CacheFailure('فشل في حفظ الفلاتر: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> clearFilters(String role) async {
    try {
      final box = await _getBox();
      final key = _getKeyForRole(role);

      await box.delete(key);

      return const Ok(null);
    } catch (e) {
      return Err(CacheFailure('فشل في حذف الفلاتر: ${e.toString()}'));
    }
  }
}
