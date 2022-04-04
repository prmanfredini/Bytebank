import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  final TextEditingController _controlador;
  final String _rotulo;
  final bool senha;
  final double padd;
  final TextInputType text;


  FormLogin(
      this._controlador,
      this._rotulo,
      {this.senha = false,
        this.padd = 8.0,
        this.text = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:padd/8, right:(2*padd), left:(2*padd)),
      child: TextFormField(
        obscureText: senha,
        controller: _controlador,
        style: const TextStyle(
          fontSize: 20.0,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Não pode estar em branco';
          }
          return null;
        },
        decoration: InputDecoration(
              labelText: _rotulo,
            ),
            keyboardType: text,
          ),
    );
  }
}