import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    required this.controller,
    required this.isLoading,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final bool isLoading;
  final Future<void> Function() onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          enabled: !isLoading,
          onSubmitted: (_) => onSubmitted(),
          decoration: const InputDecoration(
            hintText: 'Buscar medicamento, principio activo o indicacion...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onSubmitted,
            icon: const Icon(Icons.manage_search),
            label: Text(isLoading ? 'Buscando...' : 'Buscar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
