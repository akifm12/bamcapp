import 'package:flutter/material.dart';
import 'training_modules_screen.dart';

class RedFlagsScreen extends StatefulWidget {
  const RedFlagsScreen({super.key});

  @override
  State<RedFlagsScreen> createState() => _RedFlagsScreenState();
}

class _RedFlagsScreenState extends State<RedFlagsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Industry Red Flags'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Precious Metals'),
              Tab(text: 'Real Estate'),
              Tab(text: 'Financial Services'),
              Tab(text: 'DNFBPs'),
              Tab(text: 'Crypto / VASPs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(_preciousMetals),
            _buildList(_realEstate),
            _buildList(_financialServices),
            _buildList(_dnfbps),
            _buildList(_crypto),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text('View Training Modules'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrainingModulesScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<String> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                items[index],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ================= RED FLAG DATA ================= */

const List<String> _preciousMetals = [
  'Customer insists on cash transactions with no clear source of funds',
  'Rapid buying and selling of gold with no economic rationale',
  'Transactions just below reporting thresholds',
  'Use of intermediaries with unclear ownership structures',
  'Reluctance to provide KYC or beneficial ownership documents',
  'Cross-border movement of precious metals without proper documentation',
];

const List<String> _realEstate = [
  'Property purchases significantly above or below market value',
  'Use of complex corporate structures with no clear business purpose',
  'Third-party payments unrelated to the transaction',
  'Early loan repayment without justification',
  'Foreign buyers from high-risk jurisdictions',
  'Unusual urgency to close transactions',
];

const List<String> _financialServices = [
  'High-volume transactions inconsistent with customer profile',
  'Frequent movement of funds between unrelated accounts',
  'Use of multiple currencies without economic rationale',
  'Structuring transactions to avoid reporting requirements',
  'Transactions involving sanctioned or high-risk jurisdictions',
  'Resistance to enhanced due diligence',
];

const List<String> _dnfbps = [
  'Clients requesting anonymity or secrecy',
  'Unusual professional service fees',
  'Frequent changes in ownership or control',
  'Use of nominee shareholders or directors',
  'Instructions inconsistent with stated business activities',
  'Incomplete or forged documentation',
];

const List<String> _crypto = [
  'Use of privacy coins or mixers',
  'Rapid movement of assets across multiple wallets',
  'Transactions linked to darknet marketplaces',
  'Customer unwilling to disclose source of crypto funds',
  'Use of decentralized exchanges to avoid controls',
  'Transactions involving sanctioned addresses',
];
