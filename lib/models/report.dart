class Report {
  final String category;
  final String type;
  final int amount;

  Report({
    required this.category,
    required this.type,
    required this.amount,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        category: json['category'],
        type: json['type'],
        amount: json['amount'],
      );

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'type': type,
      'amount': amount,
    };
  }
}
