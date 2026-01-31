import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import 'enter_email_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStorage.getToken(),
      builder: (context, snapshot) {
        // 1️⃣ Still loading the future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ Token does NOT exist → redirect to login
        if (snapshot.data == null) {
          return const EnterEmailScreen();
        }

        // 3️⃣ Token exists → show protected screen
        return child;
      },
    );
  }
}
