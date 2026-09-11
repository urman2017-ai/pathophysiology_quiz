import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../data/questions_data.dart';

class QuizService {
  static const _historyKey = 'quiz_history_v1';

  Future<List<QuizResult>> getAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((e) => QuizResult.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<QuizResult>> getResultsForColloquium(String colloquium) async {
    final all = await getAllResults();
    return all.where((r) => r.colloquium == colloquium).toList();
  }

  Future<void> saveResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_historyKey) ?? [];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_historyKey, list);
  }

  List<Question> getRandomQuestions(String colloquium, {int count = 20}) {
    final filtered = allQuestions.where((q) => q.colloquium == colloquium).toList();
    filtered.shuffle();
    return filtered.take(count.clamp(1, filtered.length)).toList();
  }

  Future<QuizResult> finishQuiz({
    required String colloquium,
    required List<Question> questions,
    required Map<String, List<int>> answers,
  }) async {
    int score = 0;
    final mistakes = <Map<String, dynamic>>[];

    for (final q in questions) {
      final selected = answers[q.id] ?? [];
      if (q.isCorrect(selected)) {
        score++;
      } else {
        mistakes.add({
          'question': q.text,
          'selected': selected.map((i) => q.options[i]).toList(),
          'correct': q.correctAnswers.map((i) => q.options[i]).toList(),
          'explanation': q.explanation ?? 'Объяснение пока отсутствует',
        });
      }
    }

    final result = QuizResult(
      id: const Uuid().v4(),
      colloquium: colloquium,
      score: score,
      total: questions.length,
      mistakes: mistakes,
      date: DateTime.now(),
    );

    await saveResult(result);
    return result;
  }
}
