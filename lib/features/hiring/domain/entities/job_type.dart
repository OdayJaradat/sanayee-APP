
enum JobType {
  
  fullTime,

  
  partTime,

  
  gig;

  
  String toJson() => name;

  
  static JobType fromJson(String value) {
    return JobType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => JobType.gig,
    );
  }

  
  String get displayName {
    switch (this) {
      case JobType.fullTime:
        return 'دوام كامل';
      case JobType.partTime:
        return 'دوام جزئي';
      case JobType.gig:
        return 'مهمة قصيرة';
    }
  }

  
  String get icon {
    switch (this) {
      case JobType.fullTime:
        return '🕐';
      case JobType.partTime:
        return '⏰';
      case JobType.gig:
        return '⚡';
    }
  }
}
