import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.orangeAccent),
      ),
    );
  }
}
