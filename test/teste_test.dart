import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bytebank/main.dart';

void main() {
  test('Retorna o valor da transaçao', (){
    final transf = Transferencia('', 200, Contato());
    expect(transf.valor, 200);
  });
  test('error valor negativo', (){
    expect(() => Transferencia('', -200, Contato()), throwsAssertionError) ;
  });
}
