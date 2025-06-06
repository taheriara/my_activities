class Category {
  final String category;
  final String type;

  Category({
    required this.category,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        category: json['category'],
        type: json['type'],
      );

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
    };
  }
}
