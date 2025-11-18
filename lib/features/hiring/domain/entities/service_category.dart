import '../../../../core/constants/specializations.dart';


class ServiceCategory {
  final String value;

  const ServiceCategory(this.value);

  String toJson() => value;

  static ServiceCategory fromJson(String value) {
    if (Specializations.all.contains(value)) {
      return ServiceCategory(value);
    }
    return ServiceCategory(Specializations.all.first);
  }

  String get displayName => value;

  
  static List<ServiceCategory> get all {
    return Specializations.all.map((s) => ServiceCategory(s)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategory &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
