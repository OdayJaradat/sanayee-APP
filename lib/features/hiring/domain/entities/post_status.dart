
enum PostStatus {
  
  open,

  
  closed;

  
  String toJson() => name;

  
  static PostStatus fromJson(String value) {
    return PostStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => PostStatus.open,
    );
  }

  
  String get displayName {
    switch (this) {
      case PostStatus.open:
        return 'مفتوح';
      case PostStatus.closed:
        return 'مغلق';
    }
  }

  
  bool get isOpen => this == PostStatus.open;

  
  bool get isClosed => this == PostStatus.closed;
}
