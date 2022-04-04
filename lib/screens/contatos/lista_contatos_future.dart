import 'package:bytebank/components/mensagem_centro.dart';
import 'package:bytebank/components/progress_bar.dart';
import 'package:bytebank/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:bytebank/database/app_database.dart';

import '../../widgets/app_dependencies.dart';
import 'formulario_contatos.dart';
import 'model/contato_model.dart';

class ListaContatosF extends StatefulWidget {
  @override
  State<ListaContatosF> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatosF> {
  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependecies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferir'),
      ),
      body: FutureBuilder<List<Contato>>(
        future: Future.delayed(const Duration(seconds: 1))
         .then((value) => dependencies!.dataBase.initState()),
          //   .then((value) => DataBase().initState()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // caso não execute automaticamente, adc botão para inicar o futurebuild
              break;
            case ConnectionState.waiting:
              return ProgressBar();
            case ConnectionState.active:
              // barra de porcentagem
              break;
            case ConnectionState.done:
              final List<Contato> contatos = snapshot.data ?? [];
              if (contatos.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contato contato = contatos[index];
                    return ContatoModel(contato, index);
                  },
                  itemCount: contatos.length,
                );
              } else {
                return CenteredMessage(
                  'Lista de contato vazia',
                  icon: Icons.person_search,
                );
              }
          }
          return const Text('Erro inesperado');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FormContatos()))
              .then((novoContato) => setState(() => {}));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
