import 'package:bytebank/components/navegacao_listas.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../finders/funcao_home_finder.dart';

void main() {
  testWidgets('imagem', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => Saldo(0),
      ),
      ChangeNotifierProvider(
        create: (context) => Transferencias(),
      )
    ], child: DashboardContainer('pedro'))));
    final image = find.byType(Image);
    expect(image, findsOneWidget);
  });

  testWidgets('quantas features', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => Saldo(0),
      ),
      ChangeNotifierProvider(
        create: (context) => Transferencias(),
      )
    ], child: DashboardContainer('pedro'))));
    final feature = find.byType(BotoesTransf);
    expect(feature, findsNWidgets(4));
  });

  testWidgets('feature / transferir', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => Saldo(0)),
        ChangeNotifierProvider(create: (context) => Transferencias())
      ], child: DashboardContainer('pedro')),
    ));
    final transferFeature = find.byWidgetPredicate(
        (widget) => FeatureFinder(widget, 'Transferir', Icons.monetization_on));
    expect(transferFeature, findsOneWidget);
  });

  testWidgets('feature / histórico', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => Saldo(0)),
        ChangeNotifierProvider(create: (context) => Transferencias())
      ], child: DashboardContainer('pedro')),
    ));
    final transferFeature = find.byWidgetPredicate(
        (widget) => FeatureFinder(widget, 'Histórico', Icons.history));
    expect(transferFeature, findsOneWidget);
  });
}



