import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl =
      'https://blushucasa.com/app/auth';

  /* ================= REQUEST OTP ================= */
  static Future<Map<String, dynamic>> requestOtp({
    required String email,
  }) async {
    final uri = Uri.parse('$_baseUrl/request_otp.php');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    try {
      final data = jsonDecode(response.body);
      return data;
    } catch (_) {
      return {
        'success': false,
        'error': 'Invalid response from server',
      };
    }
  }

  /* ================= VERIFY OTP ================= */
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String name,
    required String phone,
    String? company,
  }) async {
    final uri = Uri.parse('$_baseUrl/verify_otp.php');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'name': name,
        'phone': phone,
        'company': company,
      }),
    );

    try {
      final data = jsonDecode(response.body);
      return data;
    } catch (_) {
      return {
        'success': false,
        'error': 'Invalid response from server',
      };
    }
  }
}
