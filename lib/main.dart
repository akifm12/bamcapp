import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

/* ===== Brand Colors (subtle & professional) ===== */
const Color primaryBlue = Color(0xFF0F2A44); // Deep navy
const Color accentBlue  = Color(0xFF1F6AE1); // Calm action blue
const Color softGrey    = Color(0xFFF4F6F8); // App background

const Color riskLow     = Color(0xFF2E7D32);   // Green
const Color riskMedium  = Color(0xFFF9A825);   // Amber
const Color riskHigh    = Color(0xFFC62828);   // Red

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

      theme: ThemeData(
        scaffoldBackgroundColor: softGrey,
        primaryColor: primaryBlue,

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

		cardTheme: CardThemeData(
		  elevation: 3,
		  margin: const EdgeInsets.symmetric(vertical: 12),
		  shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.circular(14),
		  ),
		),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}
