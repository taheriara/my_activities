class Days {
  final String regDate;
  final int? year;
  final int? month;
  final int? day;
  final String category;
  final String? details;
  final bool archive;

  Days({
    required this.regDate,
    this.year,
    this.month,
    this.day,
    required this.category,
    this.details,
    required this.archive,
  });

  factory Days.fromJson(Map<String, dynamic> json) => Days(
        regDate: json['regDate'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
        category: json['category'],
        details: json['details'],
        archive: json['archive'] != 0 ? true : false,
      );

  Map<String, dynamic> toMap() {
    return {
      'regDate': regDate,
      'year': year,
      'month': month,
      'day': day,
      'category': category,
      'details': details,
      'archive': archive ? 1 : 0,
    };
  }
}
