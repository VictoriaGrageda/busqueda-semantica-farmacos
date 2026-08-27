import 'package:flutter/material.dart';

import '../../models/medicine_result.dart';
import '../../models/search_response.dart';
import '../../services/farmaco_api_service.dart';
import '../../widgets/agent_summary_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/medicine_result_card.dart';
import '../../widgets/search_input.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FarmacoApiService _apiService = FarmacoApiService();

  List<MedicineResult> _results = const [];
  SearchResponse? _agentResponse;
  String _message = '';
  bool _isLoading = false;

  Future<void> _search() async {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        _results = const [];
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
        _results = response.results;
        _agentResponse = response;
        _message = response.results.isEmpty
            ? 'No se encontro informacion relacionada con la consulta relacionada.'
            : '';
      });
    } catch (_) {
      setState(() {
        _results = const [];
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

  @override
  void dispose() {
    _controller.dispose();
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscador farmacologico')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Consulta informacion farmacologica mediante busqueda semantica.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              SearchInput(
                controller: _controller,
                isLoading: _isLoading,
                onSubmitted: _search,
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty) EmptyState(message: _message),
              if (_isLoading) const LinearProgressIndicator(),
              if (_agentResponse != null)
                Expanded(
                  child: ListView.separated(
                    itemCount: _results.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final agentResponse = _agentResponse!;
                        return AgentSummaryCard(
                          answer: agentResponse.agentAnswer,
                          queryType: agentResponse.queryType,
                          contextRelations: agentResponse.contextRelations,
                          documentContext: agentResponse.documentContext,
                          recommendations: agentResponse.recommendations,
                          warning: agentResponse.warning,
                        );
                      }

                      return MedicineResultCard(result: _results[index - 1]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
