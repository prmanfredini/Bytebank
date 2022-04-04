import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:bytebank/components/biometria.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/dialog_atencao.dart';
import '../../components/form_login.dart';
import '../../models/cliente.dart';
import '../dashboard.dart';

class NovoCadastro extends StatefulWidget {
  const NovoCadastro({Key? key}) : super(key: key);

  @override
  State<NovoCadastro> createState() => _NovoCadastroState();
}

class _NovoCadastroState extends State<NovoCadastro> {
  // Step 1
  final _formUserKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dataController = TextEditingController();

  // Step 2
  final _formCepKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();

  // Step 3
  final _formPassKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _passController2 = TextEditingController();
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: SafeArea(
        child: Consumer<Cliente>(
          builder: (context, cliente, child) {
            return Stepper(
              currentStep: cliente.stepAtual,
              onStepContinue: () {
                final functions = [_salvarStep1, _salvarStep2, _salvarStep3];
                return functions[cliente.stepAtual](context);
              },
              onStepCancel: () {
                cliente.stepAtual =
                    cliente.stepAtual > 0 ? cliente.stepAtual - 1 : 0;
                setState(() {});
              },
              steps: _construirSteps(context, cliente),
              controlsBuilder: (BuildContext context, ControlsDetails steps) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: steps.onStepContinue,
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 20)),
                    TextButton(
                      onPressed: steps.onStepCancel,
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  _salvarStep1(context) {
    if (_formUserKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      Cliente cliente = Provider.of<Cliente>(context, listen: false);
      cliente.nome = _userController.text;
      _proximoStep(context);
    }
  }

  _salvarStep2(context) {
    if (_formCepKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _proximoStep(context);
    }
  }

  _salvarStep3(context) {
    if (_formPassKey.currentState!.validate() &&
        _passController.text == _passController2.text &&
        Provider.of<Cliente>(context, listen: false).imagem != null) {
      FocusScope.of(context).unfocus();

      Cliente cliente = Provider.of<Cliente>(context, listen: false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  DashboardContainer(cliente.nome.split(' ')[0])),
          (route) => false);
    }
  }

  _proximoStep(context) {
    Cliente cliente = Provider.of<Cliente>(context, listen: false);
    irPara(cliente.stepAtual + 1, cliente);
    setState(() {});
  }

  irPara(int step, cliente) {
    cliente.stepAtual = step;
  }

  List<Step> _construirSteps(context, cliente) {
    List<Step> step = [
      Step(
        title: const Text('Seus dados'),
        isActive: cliente.stepAtual >= 0,
        content: Form(
          key: _formUserKey,
          child: Column(children: [
            TextFormField(
              controller: _userController,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o nome';
                }
                if (!_userController.text.contains(' ')) {
                  return 'Informe um sobrenome';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _emailController,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              validator: (value) =>
                  Validator.email(value) ? 'E-mail inválido' : null,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 5),
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _phoneController,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              validator: (value) =>
                  Validator.phone(value) ? 'Telefone inválido' : null,
              decoration: const InputDecoration(
                labelText: 'Telefone',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              keyboardType: TextInputType.number,
            ),
            DateTimePicker(
              controller: _dataController,
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              initialDate: DateTime.now(),
              dateLabelText: 'Nascimento',
              style: const TextStyle(fontSize: 20),
              type: DateTimePickerType.date,
              dateMask: 'dd/MM/yyyy',
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return 'Data inválida';
                  }
                }
                return null;
              },
            ),
          ]),
        ),
      ),
      Step(
        title: const Text('Endereço'),
        isActive: cliente.stepAtual >= 1,
        content: Form(
          key: _formCepKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cepController,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o CEP';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'CEP',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(ponto: false),
                ],
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: 'Estado', labelStyle: TextStyle(fontSize: 20)),
                items: Estados.listaEstadosSigla.map((String e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  _estadoController.text = value.toString();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Informe um estado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cidadeController,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a cidade';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                ),
              ),
              TextFormField(
                controller: _ruaController,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a rua';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                ),
              ),
              TextFormField(
                controller: _numeroController,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Número',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Autenticação'),
        isActive: cliente.stepAtual >= 2,
        content: Form(
          key: _formPassKey,
          child: Column(
            children: [
              FormLogin(
                _passController,
                'Senha',
                senha: true,
                padd: 0,
              ),
              TextFormField(
                controller: _passController2,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme a senha';
                  }
                  if (_passController.text != _passController2.text) {
                    return 'As senhas não são iguais.';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Enviar foto do RG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text('Enviar foto'),
                onPressed: () => _captura(cliente),
              ),
              _imagemEnviada(context) ? _imagem(context) : _pedido(context),
              const SizedBox(height: 15),
              Biometria(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    ];
    return step;
  }

  void _captura(cliente) async {
    final pickedImage = await _picker
        .pickImage(source: ImageSource.camera)
        .then((value) => cliente.imagem = File(value!.path));
  }

  Image _imagem(context) {
    //if(Provider.of<Cliente>(context).imagem != null){
    var file = Provider.of<Cliente>(context).imagem;
    return Image.file(file!);
    //}
  }

  Text _pedido(context) {
    return const Text(
      'Favor envie a foto',
      style: TextStyle(color: Colors.red),
    );
  }

  bool _imagemEnviada(context) {
    if (Provider.of<Cliente>(context).imagem != null) {
      return true;
    }
    return false;
  }
}

Future<bool> validateEmail(email) async => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

void _validacao(BuildContext context, cpf, senha, senha2, formKey) {
  //Future.delayed(Duration(seconds: 1));
  if (formKey.currentState!.validate()) {
    if (cpf.text.length == 14 && senha.text == senha2.text) {
      showDialog(
          context: context,
          builder: (context) {
            return dialogErro(context,
                titulo: 'Atenção', erro: 'Cadastro efetuado com sucesso.');
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return dialogErro(context,
                titulo: 'Atenção', erro: 'As senhas não conferem');
          });
    }
  }
}
