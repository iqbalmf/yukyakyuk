
import 'dart:convert';

import 'package:yukyakyuk_app/page/Login.dart';

class LoginModel {
  String access_token;
  String token_type;
  String email;
  String password;

  LoginModel({
    this.email,
    this.password,
    this.access_token,
    this.token_type
  });

  factory LoginModel.fromJson(Map<String, dynamic> map) {
    return LoginModel(
        access_token: map["access_token"], token_type: map["token_type"]);
  }

  @override
  String toString() {
    return 'Login{access_token: $access_token, token_type: $token_type}';
  }

  LoginModel parseToken(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String, String>>();
    return parsed.map<LoginModel>((json) => LoginModel.fromJson(json));
  }

}
