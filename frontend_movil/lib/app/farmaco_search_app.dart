import 'package:flutter/material.dart';

import '../screens/search/search_page.dart';
import 'theme/app_theme.dart';

class FarmacoSearchApp extends StatelessWidget {
  const FarmacoSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busqueda farmacologica',
      theme: AppTheme.dark,
      home: const SearchPage(),
    );
  }
}
