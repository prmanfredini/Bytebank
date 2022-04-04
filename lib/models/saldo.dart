import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Saldo extends ChangeNotifier{
  double valor;

  Saldo(this.valor);
  var formatter = NumberFormat('#,##0.00', "EU");

  void adiciona(double valor){
    this.valor += valor;
    notifyListeners();
  }

  void subtrai(double valor){
    this.valor -= valor;
    notifyListeners();
  }


  @override
  String toString() {
    return 'R\$ ${formatter.format(valor)}';
  }
}