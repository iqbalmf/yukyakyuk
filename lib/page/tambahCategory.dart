import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yukyakyuk_app/page/Category.dart';

class TambahKategori extends StatefulWidget {
  @override
  _TambahKategoriState createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  TextEditingController namaKategori = new TextEditingController();
  TextEditingController tipeKategori = new TextEditingController();
  String nNamaKategori = '';
  String nTipeKategori = '';
  String token = '';

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tipeKategori.text = 'multi';
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('YukYakYuk'),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Tambah Kategori',
                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: namaKategori,
              decoration: InputDecoration(
                  hintText: 'Nama Toping',
                  icon: Icon(Icons.food_bank),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: tipeKategori,
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'MULTI',
                  icon: Icon(Icons.category),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: RaisedButton(
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[700],
                onPressed: () {
                  nNamaKategori = namaKategori.text;
                  nTipeKategori = tipeKategori.text;

                  if(nNamaKategori.isNotEmpty && nTipeKategori.isNotEmpty){
                    tambahKategori();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  tambahKategori() async {
    Map data = {
      'name': nNamaKategori,
      'type': nTipeKategori,
    };
    print(data.toString());
    final Response response = await post(
      'http://merchants.yukyakyuk.id/api/addon-category',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(data),
    );
    print(response.body);
    if(response.statusCode == 200){
      Map resp = jsonDecode(response.body);
      if(resp['errors'] == null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Categories()));
      } else {
        print(resp['errors']);
      }
    }
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = "${prefs.getString('tokenType')} ${prefs.getString('token')}";
    print('token pref: $token');
  }
}
