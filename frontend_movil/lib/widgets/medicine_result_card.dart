import 'package:flutter/material.dart';

import '../models/medicine_result.dart';
import 'info_row.dart';

class MedicineResultCard extends StatelessWidget {
  const MedicineResultCard({required this.result, super.key});

  final MedicineResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text('${(result.score * 100).round()}%'),
              ],
            ),
            InfoRow(
              title: 'Principio activo',
              content: result.activeIngredient,
            ),
            InfoRow(
              title: 'Grupo farmacologico',
              content: result.pharmacologicalGroup,
            ),
            InfoRow(
              title: 'Indicaciones',
              content: result.indications.join(', '),
            ),
            InfoRow(
              title: 'Contraindicaciones',
              content: result.contraindications.join(', '),
            ),
            InfoRow(
              title: 'Reacciones adversas',
              content: result.adverseReactions.join(', '),
            ),
            InfoRow(
              title: 'Via de administracion',
              content: result.administrationRoutes.join(', '),
            ),
            InfoRow(
              title: 'Forma farmaceutica',
              content: result.pharmaceuticalForms.join(', '),
            ),
          ],
        ),
      ),
    );
  }
}
