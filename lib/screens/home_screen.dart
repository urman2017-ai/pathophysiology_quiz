import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/quiz_service.dart';
import '../models/quiz_result.dart';
import 'quiz_screen.dart';
import 'history_screen.dart';
import 'result_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuizService _service = QuizService();
  Map<String, List<QuizResult>> history = {'1': [], '2': [], '4': []};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    for (final c in ['1', '2', '4']) {
      history[c] = await _service.getResultsForColloquium(c);
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Патофизиология • Коллоквиумы',
            style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard(
                  title: 'I коллоквиум',
                  subtitle: 'Общая нозология, клетка, кровообращение, аллергия, опухоли',
                  colloquium: '1',
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: 'II коллоквиум',
                  subtitle: 'Гипоксия, терморегуляция, КОС, экстремальные состояния',
                  colloquium: '2',
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: 'IV коллоквиум',
                  subtitle: 'ЖКТ, язвенная болезнь, печень, эндокринология, ЦНС',
                  colloquium: '4',
                ),
              ],
            ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String colloquium,
  }) {
    final results = history[colloquium] ?? [];
    final best = results.isEmpty ? null : results.map((r) => r.score).reduce((a, b) => a > b ? a : b);
    final last = results.isEmpty ? null : results.first;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
            const SizedBox(height: 16),
            if (results.isNotEmpty) ...[
              Text('Попыток: ${results.length}   •   Лучший: $best/20',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              if (last != null)
                Text(
                  'Последняя: ${DateFormat('dd.MM.yyyy HH:mm').format(last.date)} — ${last.score}/20',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final questions = _service.getRandomQuestions(colloquium);
                      final result = await Navigator.push<QuizResult>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            colloquium: colloquium,
                            questions: questions,
                          ),
                        ),
                      );
                      if (result != null && mounted) {
                        await _load();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultDetailScreen(result: result),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Пройти тест'),
                  ),
                ),
                if (results.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistoryScreen(
                            colloquium: colloquium,
                            results: results,
                          ),
                        ),
                      );
                    },
                    child: const Text('История'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
