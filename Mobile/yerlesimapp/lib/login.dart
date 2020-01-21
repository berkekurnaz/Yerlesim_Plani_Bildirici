import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String name;


  Future<String> verileriGetir() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("keyname");
    return "OK";
  }

  Future<String> verileriKaydet() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    await prefs.setString("keyname", txtName.text.toLowerCase());
    return "OK";
  }

  @override
  void initState() {
    super.initState();

    verileriGetir().then((value){
        if(name == null){
            print(name);
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        }
    });
  }

  TextEditingController txtName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bilgi Ekranı"),
        centerTitle: true,
      ),
      body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: TextField(
            controller: txtName,
            decoration: InputDecoration(hintText: "Adını Ve Soyadını Gir."),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: OutlineButton(
          child: Text("Bilgileri Kaydet"),
          onPressed: (){
            verileriKaydet().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            });
          },
        ),
        ),
      ],
      ),
    );
  }
}