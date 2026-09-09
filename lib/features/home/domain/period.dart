class Period {
  final int period;
  final String subject;

  Period({required this.period, required this.subject});

  factory Period.fromJson(Map<dynamic, dynamic> json) =>
      Period(period: json['period'], subject: json['subject']);
}
