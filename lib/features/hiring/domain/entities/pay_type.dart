
enum PayType {
  hourly,
  daily,
  perTask;

  String toJson() => name;

  static PayType fromJson(String value) {
    return PayType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => PayType.perTask,
    );
  }

  String get displayName {
    switch (this) {
      case PayType.hourly:
        return 'بالساعة';
      case PayType.daily:
        return 'باليوم';
      case PayType.perTask:
        return 'حسب المهمة';
    }
  }

  bool get isFixed => this == PayType.hourly || this == PayType.daily;
  bool get isRange => this == PayType.perTask;
}
