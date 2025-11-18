import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';


@singleton
class LocalitiesRepository {
  Map<String, List<String>>? _data;

  
  Future<List<String>> getGovernorates() async {
    await _ensureLoaded();
    return _data!.keys.toList()..sort();
  }

  
  Future<List<String>> getLocalitiesFor(String governorate) async {
    await _ensureLoaded();
    return _data![governorate] ?? [];
  }

  
  Future<void> _ensureLoaded() async {
    if (_data != null) return;

    final jsonString = await rootBundle.loadString(
      'assets/data/west_bank_localities_ar.json',
    );
    final Map<String, dynamic> decoded = json.decode(jsonString);

    _data = decoded.map(
      (key, value) =>
          MapEntry(key, (value as List).map((e) => e.toString()).toList()),
    );
  }
}
