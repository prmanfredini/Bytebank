import 'package:brasil_fields/brasil_fields.dart';
import 'package:bytebank/components/biometria.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:provider/provider.dart';

import '../../components/dialog_atencao.dart';
import '../../components/form_login.dart';
import '../../models/cliente.dart';
import '../dashboard.dart';
import 'novo_registro.dart';

class LoginNovo extends StatelessWidget {
  LoginNovo({Key? key}) : super(key: key);

  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: const Color.fromRGBO(71, 161, 56, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/asset/imagens/bytebank_login.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  // 300, //
                  //height: MediaQuery.of(context).size.height * 0.65, // 430, //
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _cpfController,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                            validator: (value) =>
                            Validator.cpf(value) ? 'CPF inválido' : null,
                            decoration: const InputDecoration(
                              labelText: 'CPF',
                            ),
                            maxLength: 14,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CpfInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 00),
                          //FormLogin(_userController, 'Usuário', padd: 0,),
                          FormLogin(
                            _passController,
                            'Senha',
                            senha: true,
                            padd: 0,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text(
                                'Entrar',
                                style: const TextStyle(color: Colors.green),
                              ),
                              style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        width: 2, color: Colors.green)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () {
                                _validacao(context, _cpfController,
                                    _passController, _formKey);
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueci minha senha >',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          //Biometria(),
                          const SizedBox(height: 15),
                          OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        width: 2, color: Colors.green))),
                            child: const Text('Criar uma conta >'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NovoCadastro()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void _validacao(BuildContext context, cpf, senha, formKey) {
  //Future.delayed(Duration(seconds: 1));
  if (formKey.currentState!.validate()) {
    if (cpf.text.length == 14 && senha.text == '123') {
      //Cliente cliente = Provider.of<Cliente>(context, listen: false);
      //cliente.nome = _nomeController.text;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardContainer('pedro')),
          (route) => false);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return dialogErro(context,
                titulo: 'Atenção', erro: 'CPF ou Senha inválidos');
          });
    }
  }
}
