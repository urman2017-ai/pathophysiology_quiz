import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/quiz_result.dart';

class ResultDetailScreen extends StatelessWidget {
  final QuizResult result;

  const ResultDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final percent = (result.score / result.total * 100).round();
    final color = percent >= 70
        ? Colors.green
        : (percent >= 50 ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(title: const Text('Результат попытки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: color.withOpacity(0.12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${result.score} / ${result.total}',
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text('$percent %', style: TextStyle(fontSize: 22, color: color)),
                  const SizedBox(height: 8),
                  Text(DateFormat('dd.MM.yyyy  HH:mm').format(result.date)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ошибки (${result.mistakes.length})',
            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (result.mistakes.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Ошибок нет. Отличный результат!', textAlign: TextAlign.center),
              ),
            ),
          ...result.mistakes.map((m) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['question'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text(
                      'Ваш ответ: ${(m['selected'] as List).join(', ')}',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    Text(
                      'Правильно: ${(m['correct'] as List).join(', ')}',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Объяснение: ${m['explanation']}',
                      style: TextStyle(color: Colors.grey.shade800, height: 1.35),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
