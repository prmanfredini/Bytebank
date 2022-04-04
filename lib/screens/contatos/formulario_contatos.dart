import 'package:bytebank/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/app_dependencies.dart';

class FormContatos extends StatelessWidget {

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _contaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependecies.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo Contato'),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget> [
             TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
              ),
              style:  const TextStyle(
                fontSize: 24.0
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: TextField(
                controller: _contaController,
                decoration: const InputDecoration(
                  labelText: 'Número da conta',
                ),
                  inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 24.0
                ),
                keyboardType: TextInputType.number
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      final String name = _nomeController.text;
                      final int? conta = int.tryParse(_contaController.text);
                      if (conta != null) {
                        dependencies!.dataBase.addContato(name,conta);
                        // DataBase().addContato(name,conta);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


