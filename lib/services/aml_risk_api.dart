import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class AmlRiskApi {
  static const baseUrl = 'https://blushucasa.com/app';

  static Future<Map<String, dynamic>> requestAssessment({
    required String industry,
    required String riskLevel,
    required int riskScore,
    required List<String> details,
  }) async {
    final token = await SecureStorage.getToken();

    if (token == null) {
      return {'success': false, 'error': 'Not authenticated'};
    }

    final response = await http.post(
      Uri.parse('$baseUrl/aml/request_assessment.php'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'industry': industry,
        'risk_level': riskLevel,
        'risk_score': riskScore,
        'details': details,
      }),
    );

    return jsonDecode(response.body);
  }
}
