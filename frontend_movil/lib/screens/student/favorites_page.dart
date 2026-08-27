import 'package:flutter/material.dart';

import '../../data/student_mock_data.dart';
import '../../models/medicine_result.dart';
import '../../widgets/app_gradient_header.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/medicine_result_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({required this.onOpenMedicine, super.key});

  final ValueChanged<MedicineResult> onOpenMedicine;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final List<MedicineResult> _favorites = [
    ...StudentMockData.recentMedicines.take(2),
  ];

  void _remove(MedicineResult medicine) {
    setState(() {
      _favorites.remove(medicine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          AppGradientHeader(
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Favoritos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                Text(
                  '${_favorites.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_favorites.isEmpty)
                  const EmptyState(
                    message:
                        'Guarda medicamentos para acceder rapidamente desde aqui.',
                  ),
                for (final medicine in _favorites) ...[
                  MedicineResultCard(
                    result: medicine,
                    onTap: () => widget.onOpenMedicine(medicine),
                  ),
                  TextButton.icon(
                    onPressed: () => _remove(medicine),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar de favoritos'),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
