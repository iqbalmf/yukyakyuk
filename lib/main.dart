import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yukyakyuk_app/page/Login.dart';
import 'package:yukyakyuk_app/page/homepage.dart';

void main() {
  runApp(YukyakyukApp());
}

class YukyakyukApp extends StatefulWidget {
  @override
  _YukyakyukAppState createState() => _YukyakyukAppState();
}

class _YukyakyukAppState extends State<YukyakyukApp> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _loginStatus == 1 ? Homepage() : Login(),
      debugShowCheckedModeBanner: false,
    );
  }

  var _loginStatus=0;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _loginStatus = preferences.getInt("value");
    });
  }
}

