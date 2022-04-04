import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String mensagem;

  ProgressBar({this.mensagem = 'Carregando'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Text(mensagem, style: TextStyle(fontSize: 16),),
          )
        ],
      ),
    );
  }
}
