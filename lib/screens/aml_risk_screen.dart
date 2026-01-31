import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import '../auth/enter_email_screen.dart';
import '../services/aml_risk_api.dart';

/* ===== Subtle brand colors ===== */
const Color primaryBlue = Color(0xFF0A2E5C);
const Color accentBlue = Color(0xFF1F6AE1);

const Color riskLow = Color(0xFF2E7D32);
const Color riskMedium = Color(0xFFF9A825);
const Color riskHigh = Color(0xFFC62828);

class AmlRiskScreen extends StatefulWidget {
  const AmlRiskScreen({super.key});

  @override
  State<AmlRiskScreen> createState() => _AmlRiskScreenState();
}

class _AmlRiskScreenState extends State<AmlRiskScreen> {
  String? preset;

  String? customerType;
  String? productType;
  String? countryRisk;
  String? transactionVolume;
  String? deliveryChannel;
  bool amlPolicyInPlace = true;

  int? riskScore;
  String? riskLevel;
  List<String> reasons = [];

  /* ================= PRESETS ================= */
  void applyPreset(String value) {
    setState(() {
      preset = value;

      switch (value) {
        case 'Gold & Precious Metals Trader':
          productType = 'Precious Metals';
          customerType = 'HNWI';
          transactionVolume = 'High';
          deliveryChannel = 'Face-to-face';
          countryRisk = 'Medium';
          break;

        case 'Real Estate Brokerage':
          productType = 'Real Estate';
          customerType = 'Corporate';
          transactionVolume = 'Medium';
          deliveryChannel = 'Face-to-face';
          countryRisk = 'Medium';
          break;

        case 'Professional Services Firm':
          productType = 'Professional Services';
          customerType = 'Corporate';
          transactionVolume = 'Low';
          deliveryChannel = 'Face-to-face';
          countryRisk = 'Low';
          break;

        case 'Financial Services / MSB':
          productType = 'Financial Services';
          customerType = 'Corporate';
          transactionVolume = 'High';
          deliveryChannel = 'Non-face-to-face';
          countryRisk = 'High';
          break;

        case 'Crypto / Virtual Assets':
          productType = 'Financial Services';
          customerType = 'HNWI';
          transactionVolume = 'High';
          deliveryChannel = 'Non-face-to-face';
          countryRisk = 'High';
          break;

        case 'Custom':
          break;
      }
    });
  }

  /* ================= RISK LOGIC ================= */
  Future<void> calculateRisk() async {
    final token = await SecureStorage.getToken();

    if (token == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text(
            'Create a free account to unlock AML risk scoring and compliance tools.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EnterEmailScreen(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      return;
    }

    int score = 0;
    reasons.clear();

    if (productType == 'Precious Metals' ||
        productType == 'Financial Services') {
      score += 30;
      reasons.add('High-risk products or services');
    } else if (productType == 'Real Estate') {
      score += 20;
      reasons.add('Medium-high risk sector');
    }

    if (customerType == 'HNWI') {
      score += 20;
      reasons.add('High-net-worth clients');
    } else if (customerType == 'Corporate') {
      score += 10;
      reasons.add('Corporate customers');
    }

    if (countryRisk == 'High') {
      score += 20;
      reasons.add('High-risk jurisdiction exposure');
    } else if (countryRisk == 'Medium') {
      score += 10;
      reasons.add('Medium-risk jurisdiction exposure');
    }

    if (transactionVolume == 'High') {
      score += 15;
      reasons.add('High transaction volumes');
    } else if (transactionVolume == 'Medium') {
      score += 8;
      reasons.add('Moderate transaction volumes');
    }

    if (deliveryChannel == 'Non-face-to-face') {
      score += 10;
      reasons.add('Non-face-to-face onboarding');
    }

    if (!amlPolicyInPlace) {
      score += 15;
      reasons.add('Lack of formal AML controls');
    }

    score = score > 100 ? 100 : score;

    riskLevel =
        score >= 60 ? 'HIGH' : score >= 30 ? 'MEDIUM' : 'LOW';

    riskScore = score;

    _showRiskPopup();
  }

  /* ================= POPUP ================= */
  void _showRiskPopup() {
    final Color color =
        riskLevel == 'HIGH'
            ? riskHigh
            : riskLevel == 'MEDIUM'
                ? riskMedium
                : riskLow;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Row(
          children: [
            // Accent strip
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Overall Risk: $riskLevel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Risk Score: $riskScore / 100'),
                    const Divider(height: 24),
                    Text(
                      'Key Risk Drivers',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...reasons.map((r) => Text('• $r')).toList(),
                    const SizedBox(height: 16),
                    const Text(
                      'This tool provides an indicative risk level and does not replace a formal enterprise risk assessment.',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.assignment_outlined),
                          label:
                              const Text('Request Full Assessment'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accentBlue,
                            side: BorderSide(
                                color: accentBlue.withOpacity(0.6)),
                          ),
                          onPressed: () async {
                            await AmlRiskApi.requestAssessment(
                              industry: preset ?? 'Custom',
                              riskLevel: riskLevel!,
                              riskScore: riskScore!,
                              details: reasons,
                            );

                            if (!context.mounted) return;

                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title:
                                    const Text('Request Sent'),
                                content: const Text(
                                  'Our compliance team has received your request and will contact you shortly.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AML Risk Indicator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preliminary AML Risk Indicator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _dropdown(
            label: 'Industry Preset',
            value: preset,
            items: const [
              'Gold & Precious Metals Trader',
              'Real Estate Brokerage',
              'Professional Services Firm',
              'Financial Services / MSB',
              'Crypto / Virtual Assets',
              'Custom',
            ],
            tooltip: 'Auto-fill typical AML risk factors',
            onChanged: (v) {
              if (v != null) applyPreset(v);
            },
          ),

          const Divider(height: 32),

          _dropdown(
            label: 'Customer Type',
            value: customerType,
            items: const ['Individual', 'Corporate', 'HNWI'],
            tooltip: 'HNWI clients often present higher AML risk',
            onChanged: (v) => setState(() => customerType = v),
          ),

          _dropdown(
            label: 'Product / Service',
            value: productType,
            items: const [
              'Precious Metals',
              'Real Estate',
              'Financial Services',
              'Professional Services'
            ],
            tooltip: 'Certain products are inherently higher risk',
            onChanged: (v) => setState(() => productType = v),
          ),

          _dropdown(
            label: 'Country Risk',
            value: countryRisk,
            items: const ['Low', 'Medium', 'High'],
            tooltip: 'FATF and sanctions exposure',
            onChanged: (v) => setState(() => countryRisk = v),
          ),

          _dropdown(
            label: 'Transaction Volume',
            value: transactionVolume,
            items: const ['Low', 'Medium', 'High'],
            tooltip:
                'Higher volume increases monitoring complexity',
            onChanged: (v) =>
                setState(() => transactionVolume = v),
          ),

          _dropdown(
            label: 'Delivery Channel',
            value: deliveryChannel,
            items: const ['Face-to-face', 'Non-face-to-face'],
            tooltip:
                'Non-face-to-face requires enhanced due diligence',
            onChanged: (v) =>
                setState(() => deliveryChannel = v),
          ),

          SwitchListTile(
            title:
                const Text('AML policy & procedures in place'),
            value: amlPolicyInPlace,
            onChanged: (v) =>
                setState(() => amlPolicyInPlace = v),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: calculateRisk,
            child: const Text('Calculate Risk'),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          helperText: tooltip,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (e) =>
                  DropdownMenuItem(value: e, child: Text(e)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
