import 'package:flutter/material.dart';
import 'navigation/bottom_nav.dart';
import 'core/theme.dart';

void main() {
  runApp(const BlueArrowApp());
}

class BlueArrowApp extends StatelessWidget {
  const BlueArrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blue Arrow',
      theme: blueArrowTheme,
      home: const BottomNav(),
    );
  }
}
