import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_movil/app/farmaco_search_app.dart';

void main() {
  testWidgets('muestra inicio de estudiante', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FarmacoSearchApp());

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.text('Categorias farmacologicas'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
