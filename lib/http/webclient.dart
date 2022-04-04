import 'dart:convert';

import 'package:bytebank/models/transferencia.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    //print(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    //print(data.toString());
    return data;
  }
}
class WebClient {

final Client _client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: const Duration(seconds: 10),
);

final _baseUrl = Uri.http('172.16.7.184:8080', 'transactions');
// iniciar o servidor java -jar server.jar

Future<List<Transferencia>> findAll() async {
  final Response response =
      await _client.get(_baseUrl);
  final List<dynamic> decodedJson = jsonDecode(response.body);
  return decodedJson
      .map((dynamic json) => Transferencia.fromJson(json))
      .toList();
}

Future<Transferencia> saveT(Transferencia transferencia, String senha) async {
  final String transJson = jsonEncode(transferencia.toJson());
  await Future.delayed(const Duration(seconds: 1));
  final Response response = await _client.post(_baseUrl,
      headers: {
        // a senha é 1000
        'Content-type': 'application/json',
        'password': senha,
      },
      body: transJson);

  if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202 ) {
    return Transferencia.fromJson(jsonDecode(response.body));
  }

  _errosGenericos(response.statusCode);

  throw Exception('Erro inesperado');
  //return Transferencia.fromJson(jsonDecode(response.body));

}


void _errosGenericos(int statusCode) {
  throw Exception(_statusResponses[statusCode]);
}

final Map<int, String> _statusResponses = {
  400 : 'erro ao enviar a transferencia',
  401 : 'senha incorreta',
  409 : 'transferencia duplicada'
};


}