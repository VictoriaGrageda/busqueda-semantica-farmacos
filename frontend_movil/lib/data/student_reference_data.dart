class StudentCategory {
  const StudentCategory({
    required this.name,
    required this.icon,
    required this.query,
  });

  final String name;
  final String icon;
  final String query;
}

class StudentHistoryItem {
  const StudentHistoryItem({
    required this.query,
    required this.date,
    required this.semantic,
  });

  final String query;
  final String date;
  final bool semantic;
}

class StudentReferenceData {
  static const categories = [
    StudentCategory(
      name: 'Analgesicos y Antipireticos',
      icon: 'pill',
      query: 'medicamento para fiebre y dolor',
    ),
    StudentCategory(
      name: 'Antibioticos',
      icon: 'shield',
      query: 'antibiotico para infeccion respiratoria',
    ),
    StudentCategory(
      name: 'Antiinflamatorios',
      icon: 'activity',
      query: 'antiinflamatorio para dolor',
    ),
    StudentCategory(
      name: 'Antihipertensivos',
      icon: 'heart-pulse',
      query: 'medicamento para hipertension arterial',
    ),
    StudentCategory(
      name: 'Gastrointestinales',
      icon: 'droplet',
      query: 'medicamento para gastritis',
    ),
    StudentCategory(
      name: 'Antidiabeticos',
      icon: 'syringe',
      query: 'medicamento para diabetes tipo 2',
    ),
  ];
}
