import 'dart:io';

import 'package:flutter/material.dart';

class Cliente extends ChangeNotifier {
  late String _nome;
  late String _email;
  late String _celular;
  late String _cpf;
  late String _nascimento;
  late String _cep;
  late String _estado;
  late String _senha;

//  Cliente(this._nome, this._email, this._celular, this._cpf, this._nascimento,
//      this._cep, this._estado, this._senha);

  String get nome => _nome;

  String get email => _email;

  String get celular => _celular;

  String get cpf => _cpf;

  String get nascimento => _nascimento;

  String get cep => _cep;

  String get estado => _estado;

  String get senha => _senha;

  set email(String value) {
    _email = value;
  }

  set senha(String value) {
    _senha = value;
  }

  set estado(String value) {
    _estado = value;
  }

  set cep(String value) {
    _cep = value;
  }

  set nascimento(String value) {
    _nascimento = value;
  }

  set cpf(String value) {
    _cpf = value;
  }

  set celular(String value) {
    _celular = value;
  }

  set nome(String value) {
    _nome = value;

    notifyListeners();
  }

  //cadastro do cliente
  int _stepAtual =0;
  File? _imagem;
  bool _biometria = false;


  bool get biometria => _biometria;

  set biometria(bool value) {
    _biometria = value;
  }

  File? get imagem => _imagem;

  set imagem(File? value) {
    _imagem = value;
    notifyListeners();
  }

  int get stepAtual => _stepAtual;

  set stepAtual(int value) {
    _stepAtual = value;
  }
}
