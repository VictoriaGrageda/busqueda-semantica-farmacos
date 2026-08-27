import 'package:flutter/material.dart';

import '../../models/medicine_result.dart';
import '../search/search_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'medicine_detail_page.dart';
import 'profile_page.dart';
import 'student_dashboard_page.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;
  String? _requestedQuery;

  void _openSearch([String? query]) {
    setState(() {
      _currentIndex = 1;
      _requestedQuery = query;
    });
  }

  void _openMedicine(MedicineResult medicine) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MedicineDetailPage(medicine: medicine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentDashboardPage(
        onSearchTap: _openSearch,
        onOpenMedicine: _openMedicine,
      ),
      SearchPage(
        requestedQuery: _requestedQuery,
        onOpenMedicine: _openMedicine,
      ),
      FavoritesPage(onOpenMedicine: _openMedicine),
      HistoryPage(onSearchAgain: _openSearch),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index != 1) {
              _requestedQuery = null;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.manage_search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history_toggle_off),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
