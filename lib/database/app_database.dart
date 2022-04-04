import 'package:bytebank/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBase{
  String? _contatos = Contato.encode([]);

  Future<List<Contato>> initState() {
    return _loadContatos();
  }

  Future<List<Contato>> _loadContatos() async {
    final prefs = await SharedPreferences.getInstance();
    //await preferences.clear(); // deletar tudo no bd
    _contatos = (prefs.getString('contatos'));
    return Contato.decode(_contatos ?? "[]");
  }

// Data Acess Object => DAO

//Incrementing after click
  void addContato(String name, int conta) async {
    final prefs = await SharedPreferences.getInstance();
    var contatos = Contato.decode(prefs.getString('contatos') ?? '[]');
    int num = 1;
    (contatos.isEmpty) ? num : num = contatos.last.id +1;
    final Contato novoContato = Contato(id: num, name: name,conta: conta);
    contatos.add(novoContato);
    debugPrint('adicionado ${contatos}');
    prefs.setString('contatos', Contato.encode(contatos));
  }

  void removeContato(int contato) async {
    final prefs = await SharedPreferences.getInstance();
    var contatos = Contato.decode(prefs.getString('contatos') ?? '[]');
    contatos.removeAt(contato);
    debugPrint('removido ${contatos}');
    prefs.setString('contatos', Contato.encode(contatos));
  }
}