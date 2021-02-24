import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yukyakyuk_app/model/login.dart';
import 'package:yukyakyuk_app/page/homepage.dart';
import 'package:yukyakyuk_app/service/ApiService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController emailUser = new TextEditingController();
  TextEditingController passUser = new TextEditingController();
  bool isEmailValidate = false;
  bool isPasswordValidate = false;
  String nEmailUser = "";
  String nPassUser = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('YukYakYuk'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Container(
                  width: width * 0.2,
                  height: height * 0.2,
                  child: Image.network(
                      "https://yukyakyuk.id/assets/img/Customer.jpeg"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailUser,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                      errorText: isEmailValidate ? "Enter the right email!" : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: passUser,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.visibility_off),
                      errorText: isPasswordValidate ?  "Enter right password!" : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forget Password',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      RaisedButton(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red[700],
                        onPressed: () {
                          nEmailUser = emailUser.text;
                          nPassUser = passUser.text;
                          setState(() {
                            validateTextField(nEmailUser, nPassUser);
                          });


                          if(nEmailUser.isEmpty || nPassUser.isEmpty){
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text("Form tidak boleh kosong"),
                            ));
                          }else {
                            print('$nEmailUser $nPassUser');
                            login(nEmailUser, nPassUser);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
login(email, password) async {
    Map data = {
      'email': nEmailUser,
      'password': nPassUser
    };
    print(data.toString());
    final Response response = await post(
      'http://merchants.yukyakyuk.id/api/login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if(response.statusCode == 200){
      Map resp = jsonDecode(response.body);
      if(resp['errors'] == null){
        print("token: ${resp['access_token']}");
        saveSession(1, resp['access_token'], resp['token_type']);
        print(resp['access_token']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Homepage()));
      } else {
        print(resp['errors']);
      }
    }
}

  bool validateTextField(String emailInput, String passInput) {
    if (emailInput.isEmpty) {
      setState(() {
        isEmailValidate = true;
      });
      return false;
    }
    if(passInput.isEmpty){
      setState(() {
        isPasswordValidate = true;
      });
      return false;
    }
    setState(() {
      isEmailValidate = false;
      isPasswordValidate = false;
    });
    return true;
  }

  saveSession(int value, String token, String tokenType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('value', value);
    preferences.setString('token', token);
    preferences.setString('tokenType', tokenType);
  }
}


