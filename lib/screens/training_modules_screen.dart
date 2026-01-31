import 'package:flutter/material.dart';
import 'training_module_detail_screen.dart';

class TrainingModulesScreen extends StatelessWidget {
  const TrainingModulesScreen({super.key});

  final Map<String, List<Map<String, dynamic>>> modules = const {
    'Gold & Precious Metals': [
      {
        'title': 'Cash Transactions Risk',
        'duration': '3 min',
        'scenario':
            'A customer insists on settling a high-value gold purchase entirely in cash.',
        'quiz': [
          {
            'q': 'Why is this a red flag?',
            'a': [
              'Cash reduces traceability',
              'Gold prices fluctuate',
              'Cash is illegal',
            ],
            'c': 0
          },
        ],
      },
      {
        'title': 'Source of Funds Concerns',
        'duration': '4 min',
        'scenario':
            'A client is unable to clearly explain the origin of funds used to purchase bullion.',
        'quiz': [
          {
            'q': 'What is the appropriate response?',
            'a': [
              'Proceed with caution',
              'Apply enhanced due diligence',
              'Ignore the concern',
            ],
            'c': 1
          },
        ],
      },
    ],

    'Real Estate': [
      {
        'title': 'UBO Transparency',
        'duration': '4 min',
        'scenario':
            'Property is purchased via an offshore company with no clear beneficial owner.',
        'quiz': [
          {
            'q': 'What risk does this present?',
            'a': [
              'Market risk',
              'AML / concealment risk',
              'Tax efficiency',
            ],
            'c': 1
          },
        ],
      },
      {
        'title': 'Rapid Property Flipping',
        'duration': '3 min',
        'scenario':
            'Properties are bought and sold repeatedly within short periods.',
        'quiz': [
          {
            'q': 'This behavior may indicate:',
            'a': [
              'Normal investment',
              'Layering of illicit funds',
              'Poor valuation',
            ],
            'c': 1
          },
        ],
      },
    ],

    'Financial Services / MSB': [
      {
        'title': 'Structuring Transactions',
        'duration': '5 min',
        'scenario':
            'A customer sends multiple transfers just below reporting thresholds.',
        'quiz': [
          {
            'q': 'This practice is known as:',
            'a': [
              'Batching',
              'Structuring',
              'Segmentation',
            ],
            'c': 1
          },
        ],
      },
      {
        'title': 'Rapid Cross-Border Transfers',
        'duration': '4 min',
        'scenario':
            'Funds are moved rapidly across multiple jurisdictions.',
        'quiz': [
          {
            'q': 'Primary risk involved?',
            'a': [
              'Currency fluctuation',
              'Obscuring audit trail',
              'Operational delay',
            ],
            'c': 1
          },
        ],
      },
    ],

    'Crypto / Virtual Assets': [
      {
        'title': 'Use of Mixers',
        'duration': '4 min',
        'scenario':
            'Customer uses privacy-enhancing tools before cashing out crypto.',
        'quiz': [
          {
            'q': 'Why is this risky?',
            'a': [
              'Increases volatility',
              'Obscures transaction origin',
              'Raises gas fees',
            ],
            'c': 1
          },
        ],
      },
    ],

    'Professional Services': [
      {
        'title': 'Nominee Arrangements',
        'duration': '3 min',
        'scenario':
            'Client requests nominee directors without clear justification.',
        'quiz': [
          {
            'q': 'Nominee use can indicate:',
            'a': [
              'Efficiency',
              'Concealment of ownership',
              'Regulatory compliance',
            ],
            'c': 1
          },
        ],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Modules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: modules.entries.map((industry) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                industry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: industry.value.map((module) {
                return ListTile(
                  title: Text(module['title']),
                  subtitle:
                      Text('${module['duration']} • AML Micro-Module'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainingModuleDetailScreen(
                          industry: industry.key,
                          module: module,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
