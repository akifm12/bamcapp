import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import 'enter_email_screen.dart';
import '../screens/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool loading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final storedToken = await SecureStorage.getToken();
    setState(() {
      token = storedToken;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (token != null) {
      return const HomeScreen();
    } else {
      return const EnterEmailScreen();
    }
  }
}
