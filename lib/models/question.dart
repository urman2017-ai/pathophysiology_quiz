class Question {
  final String id;
  final String text;
  final List<String> options;
  final List<int> correctAnswers;
  final String? explanation;
  final String colloquium;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswers,
    this.explanation,
    required this.colloquium,
  });

  bool isCorrect(List<int> selected) {
    if (selected.isEmpty) return false;
    final a = List<int>.from(selected)..sort();
    final b = List<int>.from(correctAnswers)..sort();
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
