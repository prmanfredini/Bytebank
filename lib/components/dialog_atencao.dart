import 'package:flutter/material.dart';

AlertDialog dialogErro(BuildContext context,
    {required titulo, required erro}) {
  return AlertDialog(
    title: Text(titulo),
    content: Text(erro),
    actions: [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK")),
    ],
  );
}
