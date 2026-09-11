import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import '../models/quiz_result.dart';

class QuizScreen extends StatefulWidget {
  final String colloquium;
  final List<Question> questions;

  const QuizScreen({
    super.key,
    required this.colloquium,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _service = QuizService();
  int currentIndex = 0;
  final Map<String, List<int>> answers = {};
  bool finishing = false;

  Question get current => widget.questions[currentIndex];

  void _toggle(int index) {
    final list = answers.putIfAbsent(current.id, () => []);
    setState(() {
      if (list.contains(index)) {
        list.remove(index);
      } else {
        list.add(index);
      }
    });
  }

  Future<void> _finish() async {
    setState(() => finishing = true);
    final result = await _service.finishQuiz(
      colloquium: widget.colloquium,
      questions: widget.questions,
      answers: answers,
    );
    if (mounted) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${currentIndex + 1} из ${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: finishing ? null : _finish,
            child: const Text('Завершить'),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / widget.questions.length,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.text,
                    style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(current.options.length, (i) {
                    final selected = answers[current.id]?.contains(i) ?? false;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: selected ? Colors.indigo.shade50 : null,
                      child: CheckboxListTile(
                        value: selected,
                        onChanged: (_) => _toggle(i),
                        title: Text(current.options[i]),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (currentIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => currentIndex--),
                        child: const Text('Назад'),
                      ),
                    ),
                  if (currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: currentIndex < widget.questions.length - 1
                          ? () => setState(() => currentIndex++)
                          : _finish,
                      child: Text(currentIndex < widget.questions.length - 1
                          ? 'Далее'
                          : 'Завершить'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
