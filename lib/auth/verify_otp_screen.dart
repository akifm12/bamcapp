import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import '../services/secure_storage.dart';
import '../screens/home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String? company;

  const VerifyOtpScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phone,
    this.company,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> verifyOtp() async {
    setState(() {
      loading = true;
      error = null;
    });

    final response = await AuthApi.verifyOtp(
      email: widget.email,
      otp: _otpController.text.trim(),
      name: widget.name,
      phone: widget.phone,
      company: widget.company,
    );

    setState(() => loading = false);

    if (response['success'] == true) {
      await SecureStorage.saveToken(response['token']);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      setState(() {
        error = response['error'] ?? 'OTP verification failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Enter the OTP sent to ${widget.email}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: loading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text('Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
