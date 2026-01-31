import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/secure_storage.dart';
import '../auth/enter_email_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await SecureStorage.getToken();
    setState(() {
      loggedIn = token != null;
    });
  }

  Future<void> _logout() async {
    await SecureStorage.deleteToken();
    setState(() {
      loggedIn = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EnterEmailScreen()),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ===================================================
          // LOGIN STATUS
          // ===================================================
          Card(
            child: ListTile(
              leading: Icon(
                loggedIn ? Icons.verified_user : Icons.person_outline,
                color: loggedIn ? Colors.green : Colors.grey,
              ),
              title: Text(
                loggedIn ? 'Logged in' : 'Not logged in',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                loggedIn
                    ? 'You have access to saved sessions & reports'
                    : 'Login to unlock advanced features',
              ),
              trailing: loggedIn
                  ? TextButton(
                      onPressed: _logout,
                      child: const Text('Logout'),
                    )
                  : TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EnterEmailScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // ===================================================
          // ABOUT BLUE ARROW
          // ===================================================
          const Text(
            'About Blue Arrow',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Blue Arrow provides practical compliance, sanctions screening, '
                'and risk intelligence tools for regulated and non-regulated businesses.\n\n'
                'Our focus is on usability, regulatory alignment, and real-world AML challenges '
                'faced by DNFBPs, traders, and professional service providers.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ===================================================
          // CONTACT
          // ===================================================
          const Text(
            'Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text('Email'),
                  subtitle: Text('info@bluearrow.ae'),
                ),
                Divider(height: 0),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Website'),
                  subtitle: Text('https://bluearrow.ae'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===================================================
          // LEGAL
          // ===================================================
          const Text(
            'Legal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      _openUrl('https://bluearrow.ae/privacy'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Use'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () =>
                      _openUrl('https://bluearrow.ae/terms'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ===================================================
          // FOOTER
          // ===================================================
          Center(
            child: Text(
              '© ${DateTime.now().year} Blue Arrow',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
