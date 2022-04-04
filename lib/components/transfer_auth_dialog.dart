import 'package:flutter/material.dart';

class AuthDialog extends StatelessWidget {
  final Function(String senha) onConfirm;
  AuthDialog({required this.onConfirm});

  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Autenticar transferência'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              key: const Key('senhaDeAutenticacao'),
              controller: _password,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 64, letterSpacing: 24),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop();
            FocusManager.instance.primaryFocus?.unfocus();
            onConfirm(_password.text);
          },
        ),
      ],
    );
  }
}
