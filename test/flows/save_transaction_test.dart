import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/contatos/model/contato_model.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/login.dart';
import 'package:bytebank/screens/transferencia/formulario_transferencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../finders/form_finder.dart';
import '../finders/funcao_home_finder.dart';
import '../mock.dart';

void main() {
  testWidgets('salvar contato', (tester) async {
    await tester.pumpWidget(
        BytebankApp(dataBase: MockDataBase(), webClient: MockWebClient(),));
    final dash = find.byType(Login);
    expect(dash, findsOneWidget);
  });

  group('funçao nova transferencia', () {
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

      //verify(MockDataBase().initState()).called(1);
      // when(MockDataBase().initState()).thenAnswer((realInvocation) async {
      //   return [Contato(name: 'Antonio')];
      // });
      //MockDataBase().addContato('Antonio', 1000);

      final contatoSelect = find.byWidgetPredicate((widget) {
        if (widget is ContatoModel) {
          return widget.contato.name == 'Antonio';
        }
        return false;
      });
      expect(contatoSelect, findsOneWidget);

      await tester.tap(contatoSelect);
      await tester.pumpAndSettle();

      // nova janela

      final valorForm = find.byType(FormularioTransferencias);
      expect(valorForm, findsOneWidget);

      final valorTextField = find
          .byWidgetPredicate((widget) => FormFinder(widget, 'Valor'));
      expect(valorTextField, findsOneWidget);
      await tester.enterText(valorTextField, '10');

      //final dialogAuth = find.byKey(senhaDeAutenticacao);

      final transferir = find.widgetWithText(ElevatedButton, 'Transferir');
      expect(transferir, findsOneWidget);
      await tester.tap(transferir);
      await tester.pumpAndSettle();

      final passwordTextField = find.byType(TextField);
      expect(passwordTextField, findsOneWidget);
      await tester.enterText(passwordTextField, '1000');

      final confirmar = find.byWidgetPredicate((widget) {
        if (widget is TextField) {
          return widget.decoration?.labelText == 'Confrimar';
        }
        return false;
      });
      expect(confirmar, findsOneWidget);

      when(MockWebClient().saveT(
          Transferencia('0', 1000, Contato(name: 'Testando', conta: 1000)),
          '1000')).thenAnswer((_) async =>
          Transferencia('0', 1000, Contato(name: 'Testando', conta: 1000))
      );

      await tester.tap(confirmar);
      await tester.pumpAndSettle();

      final sucesso = find.byType(SuccessDialog);
      expect(sucesso, findsOneWidget);
      final okButtom = find.byWidgetPredicate((widget) {
        if (widget is TextButton) {
          return widget.child == Text('Ok');
        }
        return false;
      });
      expect(okButtom, findsOneWidget);

      await tester.tap(okButtom);
      await tester.pumpAndSettle();


      // verify(MockWebClient().saveT(
      //     Transferencia('0', 1000, Contato(name: 'Testando', conta: 1000)),
      //     '1000'));

      // final contatosAddBack = find.widgetWithIcon(FloatingActionButton, Icons.add);
      // expect(contatosAddBack, findsOneWidget);

      //verify(MockHttpService().findAll());
      //verify(MockDataBase().initState()).called(1);
    });
  });
}
