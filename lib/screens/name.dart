import 'package:bytebank/components/container.dart';
import 'package:bytebank/models/name_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NameContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<NameCubit>().state;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Mudar o nome')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Digite o nome'),
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(child: const Text('Salvar'),
                  onPressed: (){
                  print('salvou');
                  final name =  _nameController.text;
                  print(name);
                  context.read<NameCubit>().change(name);
                  Navigator.of(context).pop();
                  },),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
