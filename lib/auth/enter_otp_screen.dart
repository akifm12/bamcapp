import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/secure_storage.dart';
import 'auth_gate.dart';

class EnterOtpScreen extends StatefulWidget {
  final String email;

  const EnterOtpScreen({super.key, required this.email});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool loading = false;
  String? error;
  String? responseText;

Future<void> verifyOtp() async {
  setState(() {
    loading = true;
    error = null;
    responseText = null;
  });

  try {
    final response = await http.post(
      Uri.parse('https://blushucasa.com/app/auth/verify_otp.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'otp': _otpController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

	if (response.statusCode == 200 && data['success'] == true) {
	  await SecureStorage.saveToken(data['token']);

	  if (!mounted) return;

	  Navigator.of(context).pushAndRemoveUntil(
		MaterialPageRoute(builder: (_) => const AuthGate()),
		(route) => false,
	  );
	}else {
      setState(() {
        loading = false;
        error = data['error'] ?? 'Verification failed';
      });
    }

  } catch (e) {
    setState(() {
      loading = false;
      error = 'Network error';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OTP sent to ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '6-digit OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify OTP'),
              ),
            ),
            const SizedBox(height: 20),
            if (responseText != null)
              Text(
                'Response:\n$responseText',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
