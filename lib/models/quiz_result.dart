class QuizResult {
  final String id;
  final String colloquium;
  final int score;
  final int total;
  final List<Map<String, dynamic>> mistakes;
  final DateTime date;

  QuizResult({
    required this.id,
    required this.colloquium,
    required this.score,
    required this.total,
    required this.mistakes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'colloquium': colloquium,
        'score': score,
        'total': total,
        'mistakes': mistakes,
        'date': date.toIso8601String(),
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'],
      colloquium: json['colloquium'],
      score: json['score'],
      total: json['total'],
      mistakes: List<Map<String, dynamic>>.from(json['mistakes']),
      date: DateTime.parse(json['date']),
    );
  }
}
