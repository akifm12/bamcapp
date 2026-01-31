import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import 'enter_otp_screen.dart';

class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final _emailController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> sendOtp() async {
    setState(() {
      loading = true;
      error = null;
    });

    final result =
        await AuthApi.requestOtp(_emailController.text.trim());

    setState(() => loading = false);

    if (result['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EnterOtpScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    } else {
      setState(() {
        error = result['error'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
              ),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : sendOtp,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
