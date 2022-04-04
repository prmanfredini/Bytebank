import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/mensagem_centro.dart';
import 'package:bytebank/components/progress_bar.dart';
import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contato.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'formulario_contatos.dart';
import 'model/contato_model.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingState extends ContactsListState {
  const LoadingState();
}

@immutable
class InitContactsState extends ContactsListState {
  const InitContactsState();
}

@immutable
class LoadedState extends ContactsListState {
  final List<Contato> _contacts;

  const LoadedState(this._contacts);
}

@immutable
class ErrorState extends ContactsListState {
  const ErrorState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(const InitContactsState());

  void reload() async {
    emit(const LoadingState());
    DataBase().initState().then((value) => emit(LoadedState(value)));
  }
}

class ContactsListContainer extends BlocContainer {
  ContactsListContainer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsListCubit>(
      create: (_) {
        final cubit = ContactsListCubit();
        cubit.reload();
        return cubit;
      },
      child: const ListaContatos(),
    );
  }
}

class ListaContatos extends StatelessWidget {
  const ListaContatos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferir'),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is InitContactsState || state is LoadingState) {
            return ProgressBar();
          }
          if (state is LoadedState) {
            final contatos = state._contacts;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Contato contato = contatos[index];
                return ContatoModel(contato, index);
              },
              itemCount: contatos.length,
            );
          }
          return const Text('Erro inesperado');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FormContatos(),
          ));
          context.read<ContactsListCubit>().reload();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
