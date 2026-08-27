import 'package:flutter/material.dart';

import '../../models/medicine_result.dart';
import '../../widgets/app_gradient_header.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/medicine_result_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    required this.favorites,
    required this.onOpenMedicine,
    required this.onRemoveFavorite,
    super.key,
  });

  final List<MedicineResult> favorites;
  final ValueChanged<MedicineResult> onOpenMedicine;
  final ValueChanged<MedicineResult> onRemoveFavorite;

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
                  '${favorites.length}',
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
                if (favorites.isEmpty)
                  const EmptyState(
                    message:
                        'Abre un resultado y marca el corazon para guardarlo aqui.',
                  ),
                for (final medicine in favorites) ...[
                  MedicineResultCard(
                    result: medicine,
                    onTap: () => onOpenMedicine(medicine),
                  ),
                  TextButton.icon(
                    onPressed: () => onRemoveFavorite(medicine),
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
