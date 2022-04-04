import 'package:bytebank/components/capitalize.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/screens/transferencia/formulario_transferencia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContatoModel extends StatelessWidget {
  final Contato contato;
  final int index;

  const ContatoModel(this.contato, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormularioTransferencias(contato)));
            // BlocContainer().pushPage(context, TransfContainer(contato));
          },
          child: ListTile(
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => confirmDialog(context, index, contato),
            ),
            title: Text(
              'Nome: ${contato.name.capitalize()}',
              style: const TextStyle(fontSize: 24.0),
            ),
            subtitle:
                Text('Conta: ${contato.conta.toString().padLeft(4, '0')}'),
          ),
        ),
      ),
    );
  }
}

confirmDialog(BuildContext context, int index, Contato contato) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Excluir o contato ${contato.name.capitalize()}? ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                DataBase().removeContato(index);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
