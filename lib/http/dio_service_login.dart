import 'package:bytebank/models/login_auth_model.dart';
import 'package:dio/dio.dart';

const String postsURL = "http://192.168.0.30:3000/auth/login";

class DioService {

    Future<LoginAuth> login(LoginAuth usuario) async {
    //final String loginJson = jsonEncode(usuario.toJson());
    //print(loginJson);
    await Future.delayed(const Duration(seconds: 1));
    final response = await Dio().post(postsURL,
        data: usuario);

    if (response.statusCode == 200) {
      print(response.data);
      return LoginAuth.fromJson(response.data);

    }
    throw Exception('Erro inesperado');
  }

}
