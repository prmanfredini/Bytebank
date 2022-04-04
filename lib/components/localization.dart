import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalContainer extends BlocContainer {
  final Widget child;

  LocalContainer({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    //return BlocProvider.value(value: CurrentLocalCubit(), child: child);
    return BlocProvider<CurrentLocalCubit>(
      create: (context) => CurrentLocalCubit(),
      child: child,);
  }
}

class CurrentLocalCubit extends Cubit<String> {
  CurrentLocalCubit() : super('pt-br');

}

class ViewI18N extends CurrentLocalCubit {
  String local = 'pt-br';

  ViewI18N(BuildContext context) {
    local = super.state;
    //local = BlocProvider.of<CurrentLocalCubit>(context).state;
  }


  String localize(Map<String, String> map) {
    return map[local] ?? 'label';
  }
}

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages _messages;

  const LoadedI18NMessagesState(this._messages);
}

class I18NMessages {
  final Map<String, String> _messages;

  I18NMessages(this._messages);

  String get(String key) {
    assert(_messages.containsKey(key));
    return _messages[key] ?? 'mensagem';
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18NWidget _creator;
  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>
      (builder: (context, state) {
      if (state is InitI18NMessagesState || state is LoadingI18NMessagesState) {
        return ErrorView('Carregando');
      }
      if (state is LoadedI18NMessagesState) {
        return _creator(state._messages);
      }
      return ErrorView('Erro');
    });
  }
}

typedef Widget I18NWidget (I18NMessages messages);


class I18NLoadingContainer extends BlocContainer {
  final I18NWidget _creator;
  I18NLoadingContainer(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit();
        cubit.reload();
        return cubit;
      },
      child: I18NLoadingView(this._creator),

    );
  }

}


class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  I18NMessagesCubit() : super(InitI18NMessagesState());

  void reload() {
    emit(LoadingI18NMessagesState());
    // TODO carregar
    emit(LoadedI18NMessagesState(I18NMessages({'chave': 'valor'})));
  }
}

class ErrorView extends StatelessWidget {
  final String _msg;

  const ErrorView(this._msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carregando'),),
      body: Center(child: Column(
        children: [
          ProgressBar(),
          Text(_msg),
        ],
      )),

    );
  }
}




