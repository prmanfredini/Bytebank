import 'package:bytebank/components/localization.dart';
import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/saldo.dart';
import 'package:bytebank/models/transferencias.dart';
import 'package:bytebank/screens/login.dart';
import 'package:bytebank/screens/login/login_novo.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'components/theme.dart';
import 'models/cliente.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Saldo(0),
      ),
      ChangeNotifierProvider(
        create: (context) => Transferencias(),
      ),
    ChangeNotifierProvider(
        create: (context) => Cliente(),
      )
    ],
    child: BytebankApp(webClient: WebClient(),dataBase: DataBase(),),
  ));
}

class LogObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('${bloc.runtimeType} > $change');
    super.onChange(bloc, change);
  }
}

class BytebankApp extends StatelessWidget {
  final WebClient webClient;
  final DataBase dataBase;

  const BytebankApp({Key? key, required this.webClient, required this.dataBase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Bloc.observer = LogObserver();

    return AppDependecies(
      dataBase: DataBase(),
      webClient: WebClient(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: LocalContainer(child: LoginNovo()),
      ),
    );
  }
}
