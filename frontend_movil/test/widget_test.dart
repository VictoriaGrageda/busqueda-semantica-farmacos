import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_movil/main.dart';

void main() {
  testWidgets('muestra pantalla de busqueda farmacologica', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FarmacoSearchApp());

    expect(find.text('Buscador farmacológico'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);
  });
}
