import 'package:flutter/material.dart';
import '../services/screening_api.dart';
import '../auth/enter_email_screen.dart';

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalityController = TextEditingController();

  bool loading = false;
  String? error;
  Map<String, dynamic>? result;

  Future<void> runScreening() async {
    setState(() {
      loading = true;
      error = null;
      result = null;
    });

    final response = await ScreeningApi.runScreening(
      name: _nameController.text.trim(),
      type: 'Individual',
      dob: _dobController.text.trim(),
      nationality: _nationalityController.text.trim(),
    );

    setState(() {
      loading = false;
    });

    // 🔐 LOGIN REQUIRED FLOW
    if (response['authRequired'] == true ||
        response['limit_reached'] == true) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text(
            'Create a free account to access limited sample screenings, '
            'risk indicators, and compliance insights.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EnterEmailScreen(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      return;
    }

    if (response['success'] == true) {
      setState(() {
        result = response;
      });
    } else {
      setState(() {
        error = response['error'] ?? 'Unable to reach screening service';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sanctions Screening')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Sanctions & Watchlist Screening',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // ✅ DATA SOURCES
            const Text(
              'Screening is conducted against major global sanctions databases, including thousands of records'
               ),

            const SizedBox(height: 12),

            // 🔐 GUEST NOTICE
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: const Text(
                'Create a free login to access sample screening requests.\n'
                'Contact us to subscribe and full results, risk indicators, and compliance tools.',
                style: TextStyle(fontSize: 13),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name / Entity *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Year of Birth (optional)',
                hintText: 'e.g. 1985',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nationalityController,
              decoration: const InputDecoration(
                labelText: 'Nationality (optional)',
                hintText: 'e.g. Iran',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : runScreening,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Run Screening'),
              ),
            ),

            const SizedBox(height: 24),

            if (result != null) _buildResult(result!),
			],
        ),
      ),
    );
  }

  Widget _buildResult(Map<String, dynamic> data) {
    final List results = data['results'] ?? [];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['match'] == true ? '⚠ Matches Found' : '✅ No Matches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: data['match'] == true ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text('Risk Level: ${data['risk']}'),
            Text('Total Matches: ${data['count']}'),

            if (results.isNotEmpty) ...[
              const Divider(height: 24),
              const Text(
                'Sample Matches',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...results.take(5).map<Widget>((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Source: ${r['source']}'),
                      if (r['program'] != null && r['program'] != '')
                        Text('Program: ${r['program']}'),
                      if (r['remarks'] != null && r['remarks'] != '')
                        Text(
                          'Remarks: ${r['remarks']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
} // Closes State Class