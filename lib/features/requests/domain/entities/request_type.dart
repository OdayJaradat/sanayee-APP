
enum RequestType {
  
  normal,

  
  quick;

  
  String toJson() => name;

  
  static RequestType fromJson(String value) {
    return RequestType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => RequestType.normal,
    );
  }

  
  bool get isQuick => this == RequestType.quick;

  
  bool get isNormal => this == RequestType.normal;

  
  String get displayName {
    switch (this) {
      case RequestType.normal:
        return 'طلب عادي';
      case RequestType.quick:
        return 'طلب سريع';
    }
  }
}
