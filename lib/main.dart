import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PocketBusinessCalculatorApp());
}

class PocketBusinessCalculatorApp extends StatelessWidget {
  const PocketBusinessCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pocket Business Calculator',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
