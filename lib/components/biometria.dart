import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../models/cliente.dart';

class Biometria extends StatelessWidget {
  final _autenticacao = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _bioCheck(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return SafeArea(
              child: Column(
                children: [
                  const Text('Cadastrar biometria?'),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () async {
                       await _autenticarCliente(context);
                      },
                      child: const Text('Cadastrar'),)
                ],
              ),
            );
          }
          return Container(child: const Text('Biometria nao encontrada'),);
        });
  }

  Future<bool> _bioCheck() async {
    try {
      final isAvailable = await _autenticacao.canCheckBiometrics;
      final isDeviceSupported = await _autenticacao.isDeviceSupported();
      return isAvailable; // && isDeviceSupported;
      //return await _autenticacao.canCheckBiometrics;
    } on PlatformException catch (erro) {
      print('erro $erro');
      return false;
    }
  }
  Future<void> _autenticarCliente(context) async {
    bool autenticado = false;
    autenticado = await _autenticacao.authenticate(
        localizedReason: 'Usar biometria para acessar',
        biometricOnly: true,
        useErrorDialogs: true,
    sensitiveTransaction: true,
    stickyAuth: true,
    );

    Provider.of<Cliente>(context,listen: false).biometria = autenticado;
  }
}
