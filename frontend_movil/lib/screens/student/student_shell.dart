import 'package:flutter/material.dart';

import '../../data/student_reference_data.dart';
import '../../models/medicine_result.dart';
import '../../models/search_response.dart';
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
  int _searchRequestToken = 0;
  final List<MedicineResult> _recentMedicines = [];
  final List<StudentHistoryItem> _history = [];
  final Map<String, MedicineResult> _favoritesByKey = {};

  void _openSearch([String? query]) {
    setState(() {
      _currentIndex = 1;
      _requestedQuery = query;
      if (query != null) {
        _searchRequestToken++;
      }
    });
  }

  void _openMedicine(MedicineResult medicine) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MedicineDetailPage(
          medicine: medicine,
          isFavorite: _favoritesByKey.containsKey(_medicineKey(medicine)),
          onFavoriteChanged: (isFavorite) {
            setState(() {
              _setFavorite(medicine, isFavorite);
            });
          },
        ),
      ),
    );
  }

  void _handleSearchCompleted(String query, SearchResponse response) {
    setState(() {
      _history.removeWhere((item) => item.query == query);
      _history.insert(
        0,
        StudentHistoryItem(
          query: query,
          date: 'Ahora',
          semantic: query.trim().split(RegExp(r'\s+')).length > 2,
        ),
      );

      for (final result in response.results.reversed) {
        _recentMedicines.removeWhere(
          (medicine) => _medicineKey(medicine) == _medicineKey(result),
        );
        _recentMedicines.insert(0, result);
      }

      if (_history.length > 20) {
        _history.removeRange(20, _history.length);
      }
      if (_recentMedicines.length > 10) {
        _recentMedicines.removeRange(10, _recentMedicines.length);
      }
    });
  }

  void _removeHistoryItem(StudentHistoryItem item) {
    setState(() {
      _history.remove(item);
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _removeFavorite(MedicineResult medicine) {
    setState(() {
      _favoritesByKey.remove(_medicineKey(medicine));
    });
  }

  void _setFavorite(MedicineResult medicine, bool isFavorite) {
    final key = _medicineKey(medicine);
    if (isFavorite) {
      _favoritesByKey[key] = medicine;
    } else {
      _favoritesByKey.remove(key);
    }
  }

  String _medicineKey(MedicineResult medicine) {
    return '${medicine.name}|${medicine.activeIngredient}'.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentDashboardPage(
        recentMedicines: _recentMedicines,
        onSearchTap: _openSearch,
        onOpenMedicine: _openMedicine,
      ),
      SearchPage(
        requestedQuery: _requestedQuery,
        requestToken: _searchRequestToken,
        onOpenMedicine: _openMedicine,
        onSearchCompleted: _handleSearchCompleted,
      ),
      FavoritesPage(
        favorites: _favoritesByKey.values.toList(),
        onOpenMedicine: _openMedicine,
        onRemoveFavorite: _removeFavorite,
      ),
      HistoryPage(
        history: _history,
        onSearchAgain: _openSearch,
        onRemoveItem: _removeHistoryItem,
        onClear: _clearHistory,
      ),
      ProfilePage(
        favoriteCount: _favoritesByKey.length,
        historyCount: _history.length,
        recentCount: _recentMedicines.length,
      ),
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
