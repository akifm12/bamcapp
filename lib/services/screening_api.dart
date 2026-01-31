import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class ScreeningApi {
  static const String baseUrl =
      'https://blushucasa.com/app/screening/run.php';

  static Future<Map<String, dynamic>> runScreening({
    required String name,
    required String type,
    String? dob,
    String? nationality,
  }) async {
    final token = await SecureStorage.getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'type': type,
        'dob': dob,
        'nationality': nationality,
      }),
    );

    if (response.statusCode == 401) {
      return {'authRequired': true};
    }

    if (response.statusCode == 403) {
      final data = jsonDecode(response.body);
      if (data['limitReached'] == true) {
        return {
          'limitReached': true,
          'limit': data['limit'],
        };
      }
    }

    return jsonDecode(response.body);
  }

  static Future<void> contactCompliance({
    required String name,
    required String type,
    String? dob,
    String? nationality,
  }) async {
    await http.post(
      Uri.parse(
        'https://blushucasa.com/app/screening/contact.php',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'type': type,
        'dob': dob,
        'nationality': nationality,
      }),
    );
  }
}
