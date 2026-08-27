import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({required this.title, required this.content, super.key});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = textColor.withOpacity(0.68);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: mutedColor, height: 1.35),
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: content),
          ],
        ),
      ),
    );
  }
}
