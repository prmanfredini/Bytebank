import 'package:bytebank/components/capitalize.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/localization.dart';
import 'package:bytebank/components/navegacao_listas.dart';
import 'package:bytebank/models/name_cubit.dart';
import 'package:bytebank/screens/contatos/lista_contatos_future.dart';
import 'package:bytebank/screens/deposito/formulario_deposito.dart';
import 'package:bytebank/screens/login/login_novo.dart';
import 'package:bytebank/screens/saldo_card.dart';
import 'package:bytebank/screens/transferencia/ultimas_transferencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../models/cliente.dart';
import 'name.dart';
import 'contatos/lista_contatos.dart';
import 'transferencia/lista_transferencia.dart';
import 'login.dart';

class DashboardContainer extends BlocContainer{
  var nome = 'Usuário';

  DashboardContainer(this.nome, {Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit(nome),
      child:  I18NLoadingContainer(
        //caso use as traduçoes passar o parametro
          (mensagem) => Dashboard()
      )
    );
  }
}

class Dashboard extends StatelessWidget {
  //  final String _nome;
  // const Dashboard(this._nome);

  // final I18NMessages _messages;
  // const Dashboard(this._messages);


  const Dashboard();


  @override
  Widget build(BuildContext context) {

    final _nome = context.read<NameCubit>().state;
    final _user = _nome.split('@');

    final i18n = DashboardI18N(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginNovo()));
            },
          ),
        ],
        title: Row(
          children: [
            Image.asset(
              'lib/asset/imagens/bytebank_logo.png',
              scale: 9,
            ),
            Text("Bem vindo ${_user[0].capitalize()}"),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
//                        Consumer<Cliente>(
//                          builder: (context, cliente, child) {
//                            if ()
//                          },
//                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0), child: SaldoCard()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                child: Text(i18n.deposit),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FormularioDeposito()));
                                  //BlocContainer().pushPage(context, FormularioDeposito());
                                }),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              child: Text(i18n.transfer),
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => ListaContatos()));
                                BlocContainer().pushPage(context, ContactsListContainer());
                              },
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: UltimasTransferencias(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          BotoesTransf(
                            i18n.transfer,
                            Icons.monetization_on,
                            onClick: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListaContatosF(),
                              ),
                            ),
                          ),
                          BotoesTransf(
                            i18n.history,
                            Icons.history,
                            onClick: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ListaTransferencias(),
                              ),
                            ),
                          ),
                          BotoesTransf(
                            i18n.deposit,
                            Icons.money_sharp,
                            onClick: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FormularioDeposito(),
                              ),
                            ),
                          ),
                          BotoesTransf(
                            i18n.changeName,
                            Icons.person_outline,
                            onClick: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (contextBloc) => BlocProvider.value(
                                  value: BlocProvider.of<NameCubit>(context),
                                  child: NameContainer(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardI18N extends ViewI18N{
  DashboardI18N(BuildContext context) : super(context);


  get history => localize({'pt-br': 'Histórico', 'en': 'History'});

  get deposit => localize({'pt-br': 'Depositar', 'en': 'Deposit'});

  get transfer => localize({'pt-br': 'Transferir', 'en': 'Transfer'});

  get changeName => localize({'pt-br': 'Mudar Nome', 'en': 'Change Name'});


}

