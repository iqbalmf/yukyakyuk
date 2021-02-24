import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class AddingAddOn extends StatefulWidget {
  @override
  _AddingAddOnState createState() => _AddingAddOnState();
}

class _AddingAddOnState extends State<AddingAddOn> {
  TextEditingController namaAddon = new TextEditingController();
  TextEditingController priceAddon = new TextEditingController();
  TextEditingController categoryAddon = new TextEditingController();
  String nNameAddon = '';
  String nPriceAddon = '';
  String nCategoryAddon = '';

  String token = '';

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Tambah AddOn Order',
                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: namaAddon,
              decoration: InputDecoration(
                  hintText: 'Nama Menu',
                  icon: Icon(Icons.food_bank),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: priceAddon,
              decoration: InputDecoration(
                  hintText: 'Harga',
                  icon: Icon(Icons.money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: categoryAddon,
              decoration: InputDecoration(
                  hintText: 'Kategori',
                  icon: Icon(Icons.food_bank),
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
                    nNameAddon = namaAddon.text;
                    nPriceAddon = priceAddon.text;
                    nCategoryAddon = categoryAddon.text;

                    if(nNameAddon.isNotEmpty && nPriceAddon.isNotEmpty && nCategoryAddon.isNotEmpty){
                      tambahAddon();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  tambahAddon() async {
    Map data = {
      'name': nNameAddon,
      'price': nPriceAddon,
      'addon_category_id': 74
    };
    print(data.toString());
    final Response response = await post(
      'http://merchants.yukyakyuk.id/api/addon',
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Homepage()));
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
