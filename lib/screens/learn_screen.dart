import 'package:flutter/material.dart';
import 'training_modules_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Training Modules'),
              subtitle:
                  const Text('Industry-specific AML micro-learning'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrainingModulesScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
