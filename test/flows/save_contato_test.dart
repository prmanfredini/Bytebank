import 'package:bytebank/main.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/contatos/formulario_contatos.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../finders/form_finder.dart';
import '../finders/funcao_home_finder.dart';
import '../mock.dart';

void main() {
  testWidgets('salvar contato', (tester) async {
    await tester.pumpWidget(BytebankApp(dataBase: MockDataBase(), webClient: MockWebClient(),));
    final dash = find.byType(Login);
    expect(dash, findsOneWidget);
  });

  group('funçao novo contato', () {
    testWidgets('feature / contatos', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => Saldo(0)),
          ChangeNotifierProvider(create: (context) => Transferencias())
        ], child: DashboardContainer('pedro')),
      ));
      final transferFeature = find.byWidgetPredicate((widget) =>
          FeatureFinder(widget, 'Transferir', Icons.monetization_on));
      expect(transferFeature, findsOneWidget);

      await tester.tap(transferFeature);
      await tester.pumpAndSettle();

      //verify(MockHttpService().findAll()).called(1);
      //verify(MockDataBase().initState()).called(1);

      final contatosAdd = find.widgetWithIcon(FloatingActionButton, Icons.add);
      expect(contatosAdd, findsOneWidget);
      await tester.tap(contatosAdd);
      await tester.pumpAndSettle();

      final contatoForm = find.byType(FormContatos);
      expect(contatoForm, findsOneWidget);

      final nameTextField = find
          .byWidgetPredicate((widget) => FormFinder(widget, 'Nome completo'));
      expect(nameTextField, findsOneWidget);
      await tester.enterText(nameTextField, 'Testando');

      final contaTextField = find
          .byWidgetPredicate((widget) => FormFinder(widget, 'Número da conta'));
      expect(contaTextField, findsOneWidget);
      await tester.enterText(nameTextField, '1000');

      final salvarContato = find.widgetWithText(ElevatedButton, 'Salvar');
      expect(salvarContato, findsOneWidget);
      await tester.tap(salvarContato);
      await tester.pumpAndSettle();

      //verify(MockDataBase().addContato('Testando', 1000));

      // verify(MockHttpService().saveT(
      //     Transferencia('0', 1000, Contato(name: 'Testando', conta: 1000)),
      //     '1000'));

      // final contatosAddBack = find.widgetWithIcon(FloatingActionButton, Icons.add);
      // expect(contatosAddBack, findsOneWidget);

      //verify(MockHttpService().findAll());
      //verify(MockDataBase().initState()).called(1);
    });
  });
}
