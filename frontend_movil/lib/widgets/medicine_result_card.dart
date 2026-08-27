import 'package:flutter/material.dart';

import '../models/medicine_result.dart';
import 'info_row.dart';

class MedicineResultCard extends StatelessWidget {
  const MedicineResultCard({
    required this.result,
    this.onTap,
    this.compact = true,
    super.key,
  });

  final MedicineResult result;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(result.score * 100).round()}%',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                result.activeIngredient,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.62),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Tag(label: result.pharmacologicalGroup),
                  if (result.administrationRoutes.isNotEmpty)
                    _Tag(label: result.administrationRoutes.first),
                ],
              ),
              if (result.actionMechanism != null &&
                  result.actionMechanism!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  result.actionMechanism!,
                  maxLines: compact ? 2 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.68),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
              if (!compact) ...[
                const SizedBox(height: 8),
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
                if (result.interactions.isNotEmpty)
                  InfoRow(
                    title: 'Interacciones',
                    content: result.interactions.join(', '),
                  ),
                InfoRow(
                  title: 'Via de administracion',
                  content: result.administrationRoutes.join(', '),
                ),
                InfoRow(
                  title: 'Forma farmaceutica',
                  content: result.pharmaceuticalForms.join(', '),
                ),
                if (result.sources.isNotEmpty)
                  InfoRow(title: 'Fuentes', content: result.sources.join(', ')),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
