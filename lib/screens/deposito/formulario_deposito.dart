import 'package:bytebank/components/progress_bar.dart';
import 'package:bytebank/components/transfer_auth_dialog.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class FormularioDeposito extends StatelessWidget {
  FormularioDeposito({Key? key}) : super(key: key);

  final _valueController = MoneyMaskedTextController(leftSymbol: 'R\$ ');

  //final String transfId = Uuid().v4();
  //bool _enviando = false;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposito'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Visibility(
              //   visible: _enviando,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: ProgressBar(mensagem: 'Enviando...'),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Form(
                  key: _key,
                  child: TextFormField(
                    controller: _valueController,
                    inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 24.0),
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
                  child: Consumer<Saldo>(
                    builder: (context, saldo, child) {
                      return ElevatedButton(
                        child: const Text('Confirmar'),
                        onPressed: () {
                          _criaDeposito(_valueController.text, context);
                        },
                      );
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

  void _criaDeposito(String saldo, BuildContext context) {
    if (_key.currentState!.validate()) {
      var numero = _valueController.text.split(' ');
      var aux = numero[1].replaceAll('.', '');
      var valorPonto = aux.replaceAll(',', '.');
      var valorDouble = double.parse(valorPonto);
      _atualizaEstado(context, valorDouble);
      showDialog(
          context: context,
          builder: (contextDialog) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: const Text('Dinheiro depositado com sucesso!'),
              actions: [
                TextButton(child: const Text('Ok') ,
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },)
              ],
            );
          });
    }
  }

  void _atualizaEstado(context, saldo) {
    Provider.of<Saldo>(context, listen: false).adiciona(saldo);
  }
}
