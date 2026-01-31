import 'package:flutter/material.dart';

class TrainingModuleDetailScreen extends StatefulWidget {
  final String industry;
  final Map<String, dynamic> module;

  const TrainingModuleDetailScreen({
    super.key,
    required this.industry,
    required this.module,
  });

  @override
  State<TrainingModuleDetailScreen> createState() =>
      _TrainingModuleDetailScreenState();
}

class _TrainingModuleDetailScreenState
    extends State<TrainingModuleDetailScreen> {
  int? selectedAnswer;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final quiz = widget.module['quiz'][0];

    return Scaffold(
      appBar: AppBar(title: Text(widget.module['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              widget.industry,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),

            const Text(
              'Scenario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.module['scenario']),

            const Divider(height: 32),

            const Text(
              'Knowledge Check',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(quiz['q']),

            const SizedBox(height: 12),

            ...List.generate(quiz['a'].length, (i) {
              return RadioListTile<int>(
                value: i,
                groupValue: selectedAnswer,
                title: Text(quiz['a'][i]),
                onChanged: submitted
                    ? null
                    : (v) => setState(() => selectedAnswer = v),
              );
            }),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: submitted || selectedAnswer == null
                  ? null
                  : () {
                      setState(() {
                        submitted = true;
                      });
                    },
              child: const Text('Submit Answer'),
            ),

            if (submitted)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  selectedAnswer == quiz['c']
                      ? '✅ Correct. This is a recognised AML risk indicator.'
                      : '❌ Incorrect. Review the scenario carefully.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selectedAnswer == quiz['c']
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            Text(
              'Expected Action',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Apply enhanced due diligence\n'
              '• Escalate to compliance\n'
              '• Document findings and rationale',
            ),
          ],
        ),
      ),
    );
  }
}
