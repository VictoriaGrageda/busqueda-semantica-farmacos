import 'package:flutter/material.dart';

import '../screens/student/student_shell.dart';
import 'theme/app_theme.dart';

class FarmacoSearchApp extends StatefulWidget {
  const FarmacoSearchApp({super.key});

  @override
  State<FarmacoSearchApp> createState() => _FarmacoSearchAppState();
}

class _FarmacoSearchAppState extends State<FarmacoSearchApp> {
  bool _darkModeEnabled = false;

  void _setDarkMode(bool enabled) {
    setState(() {
      _darkModeEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmaEdu Movil',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: StudentShell(
        darkModeEnabled: _darkModeEnabled,
        onDarkModeChanged: _setDarkMode,
      ),
    );
  }
}
