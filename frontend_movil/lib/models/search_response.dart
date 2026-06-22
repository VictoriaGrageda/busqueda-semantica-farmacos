import 'medicine_result.dart';

class SearchResponse {
  const SearchResponse({
    required this.originalQuery,
    required this.normalizedQuery,
    required this.resultCount,
    required this.results,
  });

  final String originalQuery;
  final String normalizedQuery;
  final int resultCount;
  final List<MedicineResult> results;

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['resultados'];

    return SearchResponse(
      originalQuery: json['consulta_original'] as String,
      normalizedQuery: json['consulta_normalizada'] as String,
      resultCount: json['cantidad_resultados'] as int,
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
}
