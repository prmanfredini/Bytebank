import 'package:bytebank/models/transferencias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lista_transferencias_provider.dart';

final _titulo = 'Últimas Transferências';

class UltimasTransferencias extends StatelessWidget {
  const UltimasTransferencias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _titulo,
          style: TextStyle(fontSize: 20),
        ),
        Consumer<Transferencias>(builder: (context, transferencias, child) {
          final reverse = transferencias.transferencias.reversed.toList();
          return reverse.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Não há transferencias',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: transferencias.transferencias.length.clamp(0, 2),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemTransferencia(reverse[index]);
                  });
        }),
        ElevatedButton(
            child: const Text('Transferencias'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListaTransfProvider()));
            }),
      ],
    );
  }
}
