import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/quiz_result.dart';
import 'result_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final String colloquium;
  final List<QuizResult> results;

  const HistoryScreen({
    super.key,
    required this.colloquium,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История • Коллоквиум $colloquium')),
      body: results.isEmpty
          ? const Center(child: Text('Пока нет попыток'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                final percent = (r.score / r.total * 100).round();
                return Card(
                  child: ListTile(
                    title: Text('${r.score}/${r.total}  ($percent%)'),
                    subtitle: Text(DateFormat('dd.MM.yyyy  HH:mm').format(r.date)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultDetailScreen(result: r),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
