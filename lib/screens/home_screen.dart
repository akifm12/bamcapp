import 'package:flutter/material.dart';

import 'tools_screen.dart';
import 'screening_screen.dart';
import 'account_screen.dart';
import 'learn_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
	  HomeTab(),
	  ToolsScreen(),
	  ScreeningScreen(),
	  LearnScreen(),
	  AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
		items: const [
		  BottomNavigationBarItem(
			icon: Icon(Icons.home),
			label: 'Home',
		  ),
		  BottomNavigationBarItem(
			icon: Icon(Icons.build),
			label: 'Tools',
		  ),
		  BottomNavigationBarItem(
			icon: Icon(Icons.search),
			label: 'Screening',
		  ),
		  BottomNavigationBarItem(
			icon: Icon(Icons.school),
			label: 'Learn',
		  ),
		  BottomNavigationBarItem(
			icon: Icon(Icons.person),
			label: 'Account',
		  ),
        ],
      ),
    );
  }
}

/* ===========================================================
   HOME TAB (NO BOTTOM NAV HERE — VERY IMPORTANT)
=========================================================== */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Arrow'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Welcome to Blue Arrow',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Practical compliance tools, sanctions screening, and AML guidance designed for real businesses.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Sanctions Screening'),
                subtitle: const Text('Screen individuals & entities'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.build),
                title: const Text('Compliance Tools'),
                subtitle: const Text('Risk indicators & red flags'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Training Modules'),
                subtitle: const Text('Industry-specific AML learning'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
