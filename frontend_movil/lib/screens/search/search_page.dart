import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../models/medicine_result.dart';
import '../../models/search_response.dart';
import '../../services/farmaco_api_service.dart';
import '../../widgets/agent_summary_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/medicine_result_card.dart';
import '../../widgets/section_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    this.requestedQuery,
    this.onOpenMedicine,
    super.key,
  });

  final String? requestedQuery;
  final ValueChanged<MedicineResult>? onOpenMedicine;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _examples = [
    'medicamento para fiebre y dolor',
    'antibiotico para infeccion respiratoria',
    'medicamento para gastritis',
    'contraindicaciones de ibuprofeno',
  ];

  final TextEditingController _controller = TextEditingController();
  final FarmacoApiService _apiService = FarmacoApiService();

  SearchResponse? _agentResponse;
  String _message = '';
  bool _isLoading = false;
  String? _lastRequestedQuery;

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final query = widget.requestedQuery;
    if (query == null || query == _lastRequestedQuery) {
      return;
    }
    _lastRequestedQuery = query;
    _controller.text = query;
    _search();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        _agentResponse = null;
        _message = 'Ingrese una consulta farmacologica.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await _apiService.searchWithAgent(query);

      setState(() {
        _agentResponse = response;
        _message = response.results.isEmpty && response.agentAnswer.isEmpty
            ? 'No se encontro informacion relacionada con la consulta.'
            : '';
      });
    } catch (_) {
      setState(() {
        _agentResponse = null;
        _message = 'No se pudo conectar con el backend.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _useExample(String example) {
    _controller.text = example;
    _search();
  }

  @override
  void dispose() {
    _controller.dispose();
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final response = _agentResponse;
    final results = response?.results ?? const <MedicineResult>[];

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  onSubmitted: (_) => _search(),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Busca por nombre, principio activo o describe...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _search,
                    icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.search,
                    ),
                    label: Text(_isLoading ? 'Buscando...' : 'Buscar'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(minHeight: 3),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                if (response == null) ...[
                  _SmartSearchCard(),
                  const SizedBox(height: 20),
                  const SectionTitle(title: 'Ejemplos de busqueda'),
                  const SizedBox(height: 10),
                  for (final example in _examples) ...[
                    _ExampleTile(
                      text: example,
                      onTap: () => _useExample(example),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 18),
                  const SectionTitle(title: 'Tambien puedes buscar por'),
                  const SizedBox(height: 10),
                  const _SearchTypesGrid(),
                ],
                if (_message.isNotEmpty) ...[
                  EmptyState(message: _message),
                  const SizedBox(height: 16),
                ],
                if (response != null) ...[
                  AgentSummaryCard(
                    answer: response.agentAnswer,
                    queryType: response.queryType,
                    contextRelations: response.contextRelations,
                    documentContext: response.documentContext,
                    recommendations: response.recommendations,
                    warning: response.warning,
                  ),
                  const SizedBox(height: 18),
                  SectionTitle(
                    title:
                        '${results.length} medicamento${results.length == 1 ? '' : 's'} encontrado${results.length == 1 ? '' : 's'}',
                    icon: Icons.fact_check_outlined,
                  ),
                  const SizedBox(height: 12),
                  if (results.isEmpty)
                    const EmptyState(
                      message:
                          'El agente encontro contexto documental, pero no una ficha estructurada de medicamento.',
                    ),
                  for (final result in results) ...[
                    MedicineResultCard(
                      result: result,
                      onTap: () => widget.onOpenMedicine?.call(result),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmartSearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accent.withOpacity(0.16),
            AppTheme.secondary.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withOpacity(0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Busqueda inteligente activa',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Describe lo que necesitas en lenguaje natural.',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.68),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.search, color: AppTheme.primary),
        title: Text(text, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.north_west, size: 16),
      ),
    );
  }
}

class _SearchTypesGrid extends StatelessWidget {
  const _SearchTypesGrid();

  static const _types = [
    'Nombre comercial',
    'Principio activo',
    'Grupo farmacologico',
    'Indicacion terapeutica',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.7,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppTheme.muted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(
            _types[index],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        );
      },
    );
  }
}
