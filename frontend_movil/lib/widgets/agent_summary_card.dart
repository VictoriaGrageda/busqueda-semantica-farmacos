import 'package:flutter/material.dart';

class AgentSummaryCard extends StatelessWidget {
  const AgentSummaryCard({
    required this.answer,
    required this.queryType,
    required this.contextRelations,
    required this.recommendations,
    required this.warning,
    super.key,
  });

  final String answer;
  final String queryType;
  final List<String> contextRelations;
  final List<String> recommendations;
  final String warning;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Respuesta del agente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(answer),
            const SizedBox(height: 10),
            Text(
              'Tipo de consulta: $queryType',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (contextRelations.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                'Relaciones semanticas usadas',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              for (final relation in contextRelations) Text('- $relation'),
            ],
            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                'Recomendaciones',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              for (final recommendation in recommendations)
                Text('- $recommendation'),
            ],
            if (warning.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(warning, style: const TextStyle(color: Colors.orangeAccent)),
            ],
          ],
        ),
      ),
    );
  }
}
