import 'dart:convert';

import 'package:http/http.dart';
import 'package:yukyakyuk_app/model/login.dart';

class ApiService {
  final String baseUrl = "http://merchants.yukyakyuk.id/api";

  Future<LoginModel> createToken(LoginModel dataToken) async {
    Map data = {
      'email': dataToken.email,
      'password': dataToken.password
    };

    final Response response = await post(
      '$baseUrl/login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if(response.statusCode == 200){
      print(json.decode(response.body));
      Map resp = json.decode(response.body);
      if(!resp['errors']){
        print('$resp[access_token]');
      }
      return LoginModel(access_token: resp['access_token'], token_type: resp['token_type']);
    } else {
      throw Exception('Failed to login');
    }
  }


}