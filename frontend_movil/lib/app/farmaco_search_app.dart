import 'package:flutter/material.dart';

import '../screens/student/student_shell.dart';
import 'theme/app_theme.dart';

class FarmacoSearchApp extends StatelessWidget {
  const FarmacoSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmaEdu Movil',
      theme: AppTheme.light,
      home: const StudentShell(),
    );
  }
}
