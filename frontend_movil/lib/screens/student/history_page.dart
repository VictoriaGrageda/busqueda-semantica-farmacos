import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../data/student_reference_data.dart';
import '../../widgets/app_gradient_header.dart';
import '../../widgets/empty_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    required this.history,
    required this.onSearchAgain,
    required this.onRemoveItem,
    required this.onClear,
    super.key,
  });

  final List<StudentHistoryItem> history;
  final ValueChanged<String> onSearchAgain;
  final ValueChanged<StudentHistoryItem> onRemoveItem;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          AppGradientHeader(
            child: Row(
              children: [
                const Icon(Icons.history, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Historial',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                if (history.isNotEmpty)
                  TextButton(
                    onPressed: onClear,
                    child: const Text(
                      'Limpiar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (history.isEmpty)
                  const EmptyState(
                    message:
                        'Tus busquedas reales apareceran aqui durante la sesion.',
                  ),
                for (final item in history) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: (item.semantic
                                          ? AppTheme.accent
                                          : AppTheme.primary)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item.semantic
                                      ? Icons.auto_awesome
                                      : Icons.search,
                                  color: item.semantic
                                      ? AppTheme.accent
                                      : AppTheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.query,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.date,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.58),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => onRemoveItem(item),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () => onSearchAgain(item.query),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Buscar de nuevo'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
