import 'medicine_result.dart';

class SearchResponse {
  const SearchResponse({
    required this.originalQuery,
    required this.normalizedQuery,
    required this.resultCount,
    required this.results,
    required this.queryType,
    required this.agentAnswer,
    required this.recommendations,
    required this.warning,
  });

  final String originalQuery;
  final String normalizedQuery;
  final int resultCount;
  final List<MedicineResult> results;
  final String queryType;
  final String agentAnswer;
  final List<String> recommendations;
  final String warning;

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['resultados'];

    return SearchResponse(
      originalQuery: json['consulta_original'] as String,
      normalizedQuery: json['consulta_normalizada'] as String,
      resultCount: json['cantidad_resultados'] as int,
      queryType: json['tipo_consulta'] as String? ?? 'consulta_general',
      agentAnswer: json['respuesta_agente'] as String? ?? '',
      recommendations: _stringList(json['recomendaciones']),
      warning: json['advertencia'] as String? ?? '',
      results: resultsJson is List
          ? resultsJson
                .map(
                  (item) =>
                      MedicineResult.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : const [],
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.map((item) => item.toString()).toList();
  }
}
