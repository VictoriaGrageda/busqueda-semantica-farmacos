class MedicineResult {
  const MedicineResult({
    required this.score,
    required this.name,
    required this.activeIngredient,
    required this.pharmacologicalGroup,
    required this.actionMechanism,
    required this.indications,
    required this.contraindications,
    required this.adverseReactions,
    required this.interactions,
    required this.administrationRoutes,
    required this.pharmaceuticalForms,
    required this.sources,
  });

  final double score;
  final String name;
  final String activeIngredient;
  final String pharmacologicalGroup;
  final String? actionMechanism;
  final List<String> indications;
  final List<String> contraindications;
  final List<String> adverseReactions;
  final List<String> interactions;
  final List<String> administrationRoutes;
  final List<String> pharmaceuticalForms;
  final List<String> sources;

  factory MedicineResult.fromJson(Map<String, dynamic> json) {
    return MedicineResult(
      score: (json['puntaje'] as num).toDouble(),
      name: json['medicamento'] as String,
      activeIngredient: json['principio_activo'] as String,
      pharmacologicalGroup: json['grupo_farmacologico'] as String,
      actionMechanism: json['mecanismo_accion'] as String?,
      indications: _stringList(json['indicaciones']),
      contraindications: _stringList(json['contraindicaciones']),
      adverseReactions: _stringList(json['reacciones_adversas']),
      interactions: _stringList(json['interacciones']),
      administrationRoutes: _stringList(json['via_administracion']),
      pharmaceuticalForms: _stringList(json['forma_farmaceutica']),
      sources: _stringList(json['fuentes']),
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) {
      return const [];
    }
    return value.map((item) => item.toString()).toList();
  }
}
