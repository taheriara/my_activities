class Cost {
  final String type;
  final String regDate;
  final int? year;
  final int? month;
  final int? day;
  final String category;
  final int amount;
  final String? details;
  final bool archive;

  Cost({
    required this.type,
    required this.regDate,
    this.year,
    this.month,
    this.day,
    required this.category,
    required this.amount,
    this.details,
    required this.archive,
  });

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        type: json['type'],
        regDate: json['regDate'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
        category: json['category'],
        amount: json['amount'],
        details: json['details'],
        archive: json['archive'] != 0 ? true : false,
      );

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'regDate': regDate,
      'year': year,
      'month': month,
      'day': day,
      'category': category,
      'amount': amount,
      'details': details,
      'archive': archive ? 1 : 0,
    };
  }
}
