import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PocketBusinessCalculatorApp());
}

class PocketBusinessCalculatorApp extends StatefulWidget {
  const PocketBusinessCalculatorApp({super.key});

  @override
  State<PocketBusinessCalculatorApp> createState() =>
      _PocketBusinessCalculatorAppState();
}

class _PocketBusinessCalculatorAppState
    extends State<PocketBusinessCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('theme_mode');

      if (!mounted) return;

      setState(() {
        if (savedTheme == 'light') {
          _themeMode = ThemeMode.light;
        } else if (savedTheme == 'dark') {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.system;
        }
      });
    } catch (_) {
      // App still opens even if preferences cannot load.
    }
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      String value = 'system';

      if (mode == ThemeMode.light) {
        value = 'light';
      } else if (mode == ThemeMode.dark) {
        value = 'dark';
      }

      await prefs.setString('theme_mode', value);
    } catch (_) {
      // Theme still changes even if saving fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalcPro Business',
      themeMode: _themeMode,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176BEF),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2475F5),
          brightness: Brightness.dark,
        ),
      ),

      home: HomeScreen(
        themeMode: _themeMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}