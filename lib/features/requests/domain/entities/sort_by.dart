enum SortBy {
  dateDesc, 
  budgetDesc, 
  distanceAsc, 
}

extension SortByExtension on SortBy {
  String get displayName {
    switch (this) {
      case SortBy.dateDesc:
        return 'الأحدث أولاً';
      case SortBy.budgetDesc:
        return 'الميزانية الأعلى';
      case SortBy.distanceAsc:
        return 'الأقرب';
    }
  }

  String toJson() {
    return name;
  }

  static SortBy fromJson(String json) {
    return SortBy.values.firstWhere(
      (e) => e.name == json,
      orElse: () => SortBy.dateDesc,
    );
  }
}
