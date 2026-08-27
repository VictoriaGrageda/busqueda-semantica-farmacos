import 'package:flutter/material.dart';

import '../app/theme/app_theme.dart';

class AgentSummaryCard extends StatelessWidget {
  const AgentSummaryCard({
    required this.answer,
    required this.queryType,
    required this.contextRelations,
    required this.documentContext,
    required this.recommendations,
    required this.warning,
    super.key,
  });

  final String answer;
  final String queryType;
  final List<String> contextRelations;
  final List<String> documentContext;
  final List<String> recommendations;
  final String warning;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: colorScheme.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Respuesta del agente',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.76),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tipo de consulta: $queryType',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (contextRelations.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Relaciones semanticas usadas',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              for (final relation in contextRelations.take(3))
                _BulletLine(text: relation),
            ],
            if (documentContext.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Contexto de manuales',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              for (final context in documentContext.take(2))
                _BulletLine(text: context),
            ],
            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Recomendaciones',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              for (final recommendation in recommendations)
                _BulletLine(text: recommendation),
            ],
            if (warning.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                warning,
                style: const TextStyle(color: AppTheme.warning, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '- ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.7),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
