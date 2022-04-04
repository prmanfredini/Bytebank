import 'package:bytebank/components/capitalize.dart';
import 'package:bytebank/components/progress_bar.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transfer_auth_dialog.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const _tituloAppBar = 'Nova Transferência';

class FormularioTransferencias extends StatelessWidget {
  final Contato contato;

  FormularioTransferencias(this.contato, {Key? key}) : super(key: key);

  final _valueController = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final String transfId = const Uuid().v4();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nome: ${contato.name.capitalize()}',
                style: const TextStyle(
                  fontSize: 32.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Nº da conta: ${contato.conta.toString().padLeft(4, '0')}',
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Form(
                  key: _key,
                  child: TextFormField(
                    controller: _valueController,
                    style: const TextStyle(fontSize: 24.0),
                    inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        labelText: 'Valor', hintText: '0.00'),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite um valor';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transferir'),
                    onPressed: () {
                      _criaTransferencia(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    if (_key.currentState!.validate()) {
      var numero = _valueController.text.split(' ');
      var aux = numero[1].replaceAll('.', '');
      var valorPonto = aux.replaceAll(',', '.');
      var valorDouble = double.parse(valorPonto);
      final transactionCreated = Transferencia(transfId, valorDouble, contato);
      showDialog(
          context: context,
          builder: (contextDialog) {
            return AuthDialog(
              onConfirm: (String senha) {
                FocusManager.instance.primaryFocus
                    ?.unfocus(); //recolher o teclado
                _save(transactionCreated, senha, context);
              },
            );
          });
    }
  }

  void _save(
      Transferencia transactionCreated,
      String senha,
      BuildContext context,
      ) async {
    var sucesso = false;
    await showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1))
              .then((value) => Navigator.pop(context));
          return SimpleDialog(children: [
            ProgressBar(mensagem: 'Enviando...'),
          ]);
        });

    final _saldo = transactionCreated.valor >
        Provider.of<Saldo>(context, listen: false).valor;

    if (_saldo) {
      await showDialog(
          context: context,
          builder: (context) {
            return FailureDialog('Saldo insuficiente.');
          });
    } else {
      await AppDependecies.of(context)?.webClient
          .saveT(transactionCreated, senha).catchError((value) {
     // await WebClient().saveT(transactionCreated, senha).catchError((value) {
        MotionToast.warning(
            title: const Text("Atenção"), description: Text(value.message))
            .show(context);
      }, test: (value) => value is Exception).whenComplete(() {
        sucesso = true;
      });
      if (sucesso) {
        Provider.of<Transferencias>(context, listen: false)
            .adiciona(transactionCreated);
        Provider.of<Saldo>(context, listen: false)
            .subtrai(transactionCreated.valor);

        showDialog(
            context: context,
            builder: (contextDialog) {
              return SuccessDialog('Transferência realizada com sucesso.');
            });
      }
    }
  }
}
