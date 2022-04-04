import 'package:bytebank/components/capitalize.dart';
import 'package:bytebank/components/mensagem_centro.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaTransfProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: Column(
        children: [
          Consumer<Transferencias>(
            builder: (context, transferencias, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: transferencias.transferencias.length,
                itemBuilder: (context, indice) {
                  final transferencia = transferencias.transferencias[indice];
                  return ItemTransferencia(transferencia);
                },
              );
            },
          ),
          Visibility(
            visible: Provider.of<Transferencias>(context, listen: false).quantidade() == 0,
            child: CenteredMessage(
              'Não há transações',
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _ted;

  ItemTransferencia(this._ted);

  @override
  Widget build(BuildContext context) {
    String nome = _ted.contato.name.capitalize();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text('${Saldo(_ted.valor)}'),
        subtitle: Text(
            'Para: $nome  |  Conta N.º: ${_ted.contato.conta.toString().padLeft(4, '0')}'),
      ),
    );
  }
}
