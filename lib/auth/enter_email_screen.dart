import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import 'verify_otp_screen.dart';

class EnterEmailScreen extends StatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });

    final response = await AuthApi.requestOtp(
			email: _emailController.text.trim(),
			);
    setState(() {
      loading = false;
    });

    if (response['success'] == true) {
      if (!mounted) return;

		Navigator.push(
		  context,
		  MaterialPageRoute(
			builder: (_) => VerifyOtpScreen(
			  email: _emailController.text.trim(),
			  name: _nameController.text.trim(),
			  phone: _phoneController.text.trim(),
			  company: _companyController.text.trim().isEmpty
				  ? null
				  : _companyController.text.trim(),
			),
		  ),
		);
	  
    } else {
      setState(() {
        error = response['error'] ?? 'Failed to send OTP';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter your details to access compliance tools',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              /* ===== NAME ===== */
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),

              /* ===== PHONE ===== */
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: '+971…',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 12),

              /* ===== COMPANY (OPTIONAL) ===== */
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company (optional)',
                ),
              ),
              const SizedBox(height: 12),

              /* ===== EMAIL ===== */
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!v.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : sendOtp,
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send OTP'),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'We’ll send a one-time password to your email to verify your account.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
