import 'dart:async';
import 'dart:core';

import 'package:bytebank/components/form_login.dart';
import 'package:bytebank/http/dio_service_login.dart';
import 'package:bytebank/models/login_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/dialog_atencao.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

enum StatePage { LOADING, LOGIN, FORGET }

class _LoginState extends State<Login> {
  final _controllerUser = TextEditingController();
  final _controllerPswd = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool rememberUser = false;

  final StreamController<StatePage> _streamController =
  StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text('imagem')
                      // Image(
                      //   image: AssetImage("lib/asset/images/iteris_logo.png"),
                      //   width: 200,
                      // ),
                    ),
                    StreamBuilder<StatePage>(
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final state = snapshot.data ?? StatePage.LOGIN;
                            switch (state) {
                              case StatePage.LOADING:
                                return const Padding(
                                  padding: EdgeInsets.all(90.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              case StatePage.LOGIN:
                                return buttonLogin();
                              case StatePage.FORGET:
                                return buttonEmail();
                            }
                          } else {
                            return buttonLogin();
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonEmail() => Form(
    key: _key,
    child: Column(children: [
      const Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        child: Text("Esqueci a senha", style: TextStyle(fontSize: 20.0)),
      ),
      FormLogin(_controllerUser, 'E-mail'),
      Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  onClickEmail();
                },
                child: const Text("Enviar e-mail")),
          ),
          ElevatedButton(
              onPressed: () {
                _streamController.add(StatePage.LOGIN);
              },
              child: const Text("Voltar para login")),
        ]),
      ),
    ]),
  );

  Widget buttonLogin() => FutureBuilder(
    future: getUser(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        _controllerUser.text = snapshot.data.toString();
        rememberUser = !rememberUser;
      }
      return _form(_controllerUser, _controllerPswd);
    },
  );

  getUser() async {
    final user = await SharedPreferences.getInstance();
    String nome = user.getString('USER') ?? "";
    return nome;
  }

  Form _form(_user, _pass) {
    return Form(
      key: _key,
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Text("Login", style: TextStyle(fontSize: 20.0)),
        ),
        FormLogin(_user, 'Usuário'),
        FormLogin(_pass, 'Senha', senha: true),
        Center(
          child: Column(children: [
            CheckboxListTile(
              //dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Lembrar usuário'),
                value: rememberUser,
                onChanged: (bool? value) => setState(() {
                  rememberUser = !rememberUser;
                })),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                  onPressed: () => onClickLogin(_controllerUser.text),
                  //onClickApi(_controllerUser.text, _controllerPswd.text),
                  child: Text("Login")),
            ),
            ElevatedButton(
                onPressed: () {
                  _streamController.add(StatePage.FORGET);
                },
                child: const Text("Esqueci a senha")),
          ]),
        ),
      ]),
    );
  }

  onClickLogin(String _user,) async {
    if (rememberUser) {
      final user = await SharedPreferences.getInstance();
      user.setString('USER', _user);
    } else {
      final user = await SharedPreferences.getInstance();
      user.clear();
      user.setString('USER', '');
    }
    if (_key.currentState!.validate()) {
      validateLogin().then((isValid) {
        validacao(isValid, "Login ou senha incorretos");
      });
    }
  }

  //onClickApi(_controllerUser.text,_controllerPswd.text) //onClickLogin()

  onClickApi(String _user, String _pass) async {
    if (rememberUser) {
      final user = await SharedPreferences.getInstance();
      user.setString('USER', _user);
    } else {
      final user = await SharedPreferences.getInstance();
      user.clear();
      user.setString('USER', '');
    }
    debugPrint('usuario: $_user senha : $_pass');
    final LoginAuth loginAuth =
    await DioService().login(LoginAuth(user: _user, pass: _pass));
    showDialog(
        context: context,
        builder: (context) {
          return _alertDialog(
              loginAuth.msg, loginAuth.status, loginAuth.code, context);
        });
  }

  AlertDialog _alertDialog(
      String msg, String status, int code, BuildContext context) {
    return AlertDialog(
      title: Text(status),
      content: Text(msg),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (code == 1) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DashboardContainer(_controllerUser.text)));
              } else {
                Navigator.pop(context);
              }
            },
            child: Text("OK")),
      ],
    );
  }

  onClickEmail() async {
    final email = _controllerUser.text;
    _key.currentState!.validate();
    validateEmail(email).then((isValid) {
      validacaoMail(isValid, "E-mail inválido");
    });
  }

  void validacaoMail(bool isValid, String erro) {
    Future.delayed(const Duration(seconds: 1), () {
      _streamController.add(StatePage.FORGET);
      if (!isValid) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Atenção"),
                content: Text(erro),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK")),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Sucesso!"),
                content: Text('E-mail enviado para ${_controllerUser.text}'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _streamController.add(StatePage.LOGIN);
                      },
                      child: Text("Login")),
                ],
              );
            });
      }
    });
  }

  void validacao(bool isValid, String erro) {
    Future.delayed(const Duration(seconds: 1), () {
      //_streamController.add(StatePage.LOGIN);
      if (!isValid) {
        showDialog(context: context, builder: (context){
          return dialogErro(context, titulo: 'Atenção', erro: erro);
        });
      } else {
        _streamController.add(StatePage.LOADING);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashboardContainer(_controllerUser.text),
          ));
        });
      }
    });
  }

  Future<bool> validateLogin() async {
    return (_controllerUser.text.toLowerCase() == 'pedro' ||
        _controllerUser.text.toLowerCase() == 'pedro@iteris.com' &&
            _controllerPswd.text == '123');
  }

  Future<bool> validateEmail(email) async => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  Dialog_email() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Atenção"),
            content: Text("E-mail com redefinição de senha enviado!"),
            actions: [
              TextButton(
                  onPressed: () {
                    _streamController.add(StatePage.LOGIN);
                    Navigator.pop(context);
                  },
                  child: Text("Login")),
            ],
          );
        });
  }
}