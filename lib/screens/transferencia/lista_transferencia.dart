import 'package:bytebank/components/capitalize.dart';
import 'package:bytebank/components/mensagem_centro.dart';
import 'package:bytebank/components/progress_bar.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

class ListaTransferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: FutureBuilder<List<Transferencia>>(
        future: WebClient().findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return ProgressBar();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Transferencia> transferencias = snapshot.data ?? [];
              if (transferencias.isNotEmpty){
                return ListView.builder(
                  itemCount: transferencias.length,
                  itemBuilder: (context, indice) {
                    final transferencia = transferencias[indice];
                    return ItemTransferencia(transferencia);
                  },
                );
              }
                return CenteredMessage(
                  'Não há transações',
                  icon: Icons.warning,
                );
          }
          return CenteredMessage(
            'Erro inesperado',
            icon: Icons.code_off,
          );
        },
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
            'Para: ${nome}  |  Conta N.º: ${_ted.contato.conta.toString().padLeft(4, '0')}'),
      ),
    );
  }
}
