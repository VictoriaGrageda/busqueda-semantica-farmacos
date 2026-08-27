import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../models/medicine_result.dart';
import '../../widgets/app_chip.dart';
import '../../widgets/app_gradient_header.dart';
import '../../widgets/medicine_result_card.dart';

class MedicineDetailPage extends StatefulWidget {
  const MedicineDetailPage({required this.medicine, super.key});

  final MedicineResult medicine;

  @override
  State<MedicineDetailPage> createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  final Set<String> _expandedSections = {'mecanismo', 'indicaciones'};
  bool _isFavorite = false;

  void _toggleSection(String id) {
    setState(() {
      if (_expandedSections.contains(id)) {
        _expandedSections.remove(id);
      } else {
        _expandedSections.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;
    final sections = [
      _DetailSection(
        id: 'mecanismo',
        title: 'Mecanismo de accion',
        icon: Icons.bolt_outlined,
        color: AppTheme.primary,
        text: medicine.actionMechanism ?? 'Sin mecanismo registrado.',
      ),
      _DetailSection(
        id: 'indicaciones',
        title: 'Indicaciones terapeuticas',
        icon: Icons.track_changes,
        color: AppTheme.secondary,
        items: medicine.indications,
      ),
      _DetailSection(
        id: 'contraindicaciones',
        title: 'Contraindicaciones',
        icon: Icons.report_problem_outlined,
        color: AppTheme.danger,
        items: medicine.contraindications,
      ),
      _DetailSection(
        id: 'reacciones',
        title: 'Reacciones adversas',
        icon: Icons.warning_amber_outlined,
        color: AppTheme.warning,
        items: medicine.adverseReactions,
      ),
      _DetailSection(
        id: 'interacciones',
        title: 'Interacciones',
        icon: Icons.compare_arrows,
        color: const Color(0xFF9C27B0),
        items: medicine.interactions,
      ),
      _DetailSection(
        id: 'presentaciones',
        title: 'Formas y vias',
        icon: Icons.medication_liquid_outlined,
        color: const Color(0xFF00A6C8),
        items: [
          ...medicine.pharmaceuticalForms,
          ...medicine.administrationRoutes,
        ],
      ),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppGradientHeader(
                padding: const EdgeInsets.fromLTRB(12, 12, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        const Expanded(
                          child: Text(
                            'Detalle del medicamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.ios_share),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      medicine.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.activeIngredient,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.86),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppChip(
                          label: medicine.pharmacologicalGroup,
                          color: Colors.white,
                        ),
                        if (medicine.sources.isNotEmpty)
                          AppChip(
                            label: medicine.sources.first,
                            icon: Icons.menu_book_outlined,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList.list(
                children: [
                  for (final section in sections) ...[
                    _ExpandableDetailSection(
                      section: section,
                      expanded: _expandedSections.contains(section.id),
                      onTap: () => _toggleSection(section.id),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    'Ficha resumida',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  MedicineResultCard(result: medicine, compact: false),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection {
  const _DetailSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.text,
    this.items = const [],
  });

  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String? text;
  final List<String> items;
}

class _ExpandableDetailSection extends StatelessWidget {
  const _ExpandableDetailSection({
    required this.section,
    required this.expanded,
    required this.onTap,
  });

  final _DetailSection section;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = section.items.isEmpty
        ? [section.text ?? 'Sin datos registrados.']
        : section.items;

    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(section.icon, color: section.color, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  for (final item in content) _DetailLine(text: item),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('- ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.72),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
