import 'contato.dart';

class Transferencia {
  final String id;
  final double valor;
  final Contato contato;

  Transferencia(this.id, this.valor, this.contato) : assert(valor > 0);


  // ---------- Json da API ----------

  Transferencia.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        valor = json['value'],
        contato = Contato.fromJ(json['contact']);

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'value' : valor,
        'contact' : contato.toJson(),
      };

  String toStringValor(){
    return 'R\$ $valor';
  }

   String toStringConta(){
    return 'Conta: ${contato.conta}';
  }

  @override
  String toString() {
    return 'Transferência no valor de R\$: ${valor.toStringAsFixed(2)} para: ${contato}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transferencia &&
          runtimeType == other.runtimeType &&
          valor == other.valor &&
          contato == other.contato;

  @override
  int get hashCode => valor.hashCode ^ contato.hashCode;
}
