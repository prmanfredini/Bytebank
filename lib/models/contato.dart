import 'dart:convert';

class Contato {
  final int id;
  final String name;
  final int conta;

  Contato({this.name = '', this.conta = 0, this.id = 0});

  @override
  String toString() {
    return 'Contatos{id: $id, name: $name, conta: $conta}';
  }

  // ----------  Json interno da persistencia de dados ----------
  factory Contato.fromJson(Map<String, dynamic> jsonData) {
    return Contato(
      id: jsonData['id'],
      name: jsonData['name'],
      conta: jsonData['conta'],
    );
  }

  static Map<String, dynamic> toMap(Contato contatos) => {
        'id': contatos.id,
        'name': contatos.name,
        'conta': contatos.conta,
      };

  static String encode(List<Contato> contatoss) => json.encode(
        contatoss
            .map<Map<String, dynamic>>((contatos) => Contato.toMap(contatos))
            .toList(),
      );

  static List<Contato> decode(String contatoss) =>
      (json.decode(contatoss) as List<dynamic>)
          .map<Contato>((item) => Contato.fromJson(item))
          .toList();


  // ---------- Json da API ----------

  Contato.fromJ(Map<String, dynamic> jsons)
      : id = 0,
        name = jsons['name'],
        conta = jsons['accountNumber'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'accountNumber': conta,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contato &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          conta == other.conta;

  @override
  int get hashCode => name.hashCode ^ conta.hashCode;
}
