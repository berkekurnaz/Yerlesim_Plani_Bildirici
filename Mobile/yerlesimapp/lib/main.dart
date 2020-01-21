import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Login(),
      "/home": (context) => Home(),
    },
  ));
}
