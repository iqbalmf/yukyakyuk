import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yukyakyuk_app/model/addon.dart';
import 'package:yukyakyuk_app/page/Category.dart';
import 'package:yukyakyuk_app/page/Login.dart';
import 'package:yukyakyuk_app/page/tambahaddon.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String token = '';

  @override
  void initState() {
    // TODO: implement initState
    this.getToken();
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
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                logout();
                removeToken();

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => Login()));
              })
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Addon',
                      style: TextStyle(fontSize: height * 0.04),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Categories()));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                        child: Text(
                          'Lihat kategori',
                          style: TextStyle(
                              fontSize: width * 0.04, color: Colors.red[500]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: FutureBuilder(
                      future: getDataAddon(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    print(
                                        '${snapshot.data[index]} ${snapshot.data[index]['price']}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      color: Colors.red[100],
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              snapshot.data[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                12, 0, 0, 10),
                                            child: Text(
                                              'Price: ${snapshot.data[index]['price']}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddingAddOn()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red[900],
      ),
    );
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = "${prefs.getString('tokenType')} ${prefs.getString('token')}";
    });
    print('token pref: $token');
  }

  removeToken() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    await perf.clear();
  }

  Future<List<dynamic>> getDataAddon() async {
    var response = await get(
        Uri.encodeFull("http://merchants.yukyakyuk.id/api/addons"),
        headers: {"Content-Type": "application/json", "Authorization": token});
    print(jsonDecode(response.body)['data']);
    return json.decode(response.body)['data'];
  }

  logout() async {
    final Response response = await post(
      'http://merchants.yukyakyuk.id/api/logout',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '$token'
      },
    );
    return json.decode(response.body);
  }
}
