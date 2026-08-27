import '../models/medicine_result.dart';

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

class StudentMockData {
  static const categories = [
    StudentCategory(
      name: 'Analgesicos',
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
      name: 'Gastrointestinales',
      icon: 'droplet',
      query: 'medicamento para gastritis',
    ),
  ];

  static const history = [
    StudentHistoryItem(
      query: 'medicamento para fiebre',
      date: 'Hoy',
      semantic: true,
    ),
    StudentHistoryItem(
      query: 'Paracetamol',
      date: 'Ayer',
      semantic: false,
    ),
    StudentHistoryItem(
      query: 'antibiotico para infeccion respiratoria',
      date: 'Esta semana',
      semantic: true,
    ),
  ];

  static const recentMedicines = [
    MedicineResult(
      score: 0.98,
      name: 'Paracetamol',
      activeIngredient: 'Paracetamol',
      pharmacologicalGroup: 'Analgesico y antipiretico',
      actionMechanism:
          'Inhibe la sintesis de prostaglandinas a nivel central.',
      indications: ['dolor', 'fiebre'],
      contraindications: [
        'hipersensibilidad al principio activo',
        'insuficiencia hepatica grave',
      ],
      adverseReactions: [
        'nauseas',
        'rash cutaneo',
        'hepatotoxicidad en sobredosis',
      ],
      interactions: ['alcohol', 'anticoagulantes orales'],
      administrationRoutes: ['oral'],
      pharmaceuticalForms: ['tableta', 'jarabe'],
      sources: ['Base academica'],
    ),
    MedicineResult(
      score: 0.95,
      name: 'Omeprazol',
      activeIngredient: 'Omeprazol',
      pharmacologicalGroup: 'Inhibidor de la bomba de protones',
      actionMechanism:
          'Disminuye la secrecion acida gastrica en celulas parietales.',
      indications: ['gastritis', 'reflujo gastroesofagico'],
      contraindications: ['hipersensibilidad al principio activo'],
      adverseReactions: ['cefalea', 'nauseas', 'dolor abdominal'],
      interactions: ['clopidogrel'],
      administrationRoutes: ['oral'],
      pharmaceuticalForms: ['capsula'],
      sources: ['Base academica'],
    ),
    MedicineResult(
      score: 0.93,
      name: 'Ibuprofeno',
      activeIngredient: 'Ibuprofeno',
      pharmacologicalGroup: 'Antiinflamatorio no esteroideo',
      actionMechanism:
          'Inhibe ciclooxigenasas y reduce prostaglandinas relacionadas con dolor e inflamacion.',
      indications: ['dolor', 'inflamacion', 'fiebre'],
      contraindications: ['ulcera gastrica activa', 'hipersensibilidad a AINEs'],
      adverseReactions: ['dolor gastrico', 'nauseas', 'sangrado digestivo'],
      interactions: ['anticoagulantes', 'otros AINEs'],
      administrationRoutes: ['oral'],
      pharmaceuticalForms: ['tableta', 'suspension'],
      sources: ['Base academica'],
    ),
  ];
}
