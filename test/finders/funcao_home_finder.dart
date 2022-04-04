import 'package:bytebank/components/navegacao_listas.dart';
import 'package:flutter/material.dart';

bool FeatureFinder(Widget widget, String nome, IconData icon) {
  if (widget is BotoesTransf) {
    return widget.nome == nome && widget.icon == icon;
  }
  return false;
}
