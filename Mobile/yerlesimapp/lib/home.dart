import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SocketIO socketIO;
  List<String> messages;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String name;
  String resultSinif;
  String resultKoltuk;

  Future<String> verileriGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("keyname");
    return "OK";
  }

  @override
  void initState() {
    super.initState();

    verileriGetir().then((value) {
      print(name);
    });

    //Initializing the message list
    messages = List<String>();

    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'http://10.0.2.2:5000',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();

    //Subscribe to an event to listen to
    socketIO.subscribe('students_list', (jsonData) {
      var data = json.decode(jsonData);
      print(data);
      for (var i = 0; i < data.length; i++) {
        if (data[i]["ad"].toString().toLowerCase().contains(name)) {
          print("Veri Geldi");
          setState(() {
              resultSinif = data[i]["sinif"];
              resultKoltuk = data[i]["koltuk"];
          });
          messages.add(data[i]["ad"] +
              " - " +
              data[i]["sinif"] +
              " - " +
              data[i]["koltuk"]);
        }
      }
      if (resultSinif.length > 1) {
        print("Veri Geldi Girildir");
        showNotification(resultSinif, resultKoltuk);
      }
    });

    //Connect to the socket
    socketIO.connect();

    // Notification System
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Bildirim'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification(String sinif, String koltuk) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, 'Sınıf Bilgileri Açıklandı',
        '${sinif} Sınıfı ${koltuk} Numarası', platform,
        payload: '${sinif} Sınıfı ${koltuk} Numarasında Sınava Gireceksin.');
  }

  @override
  Widget build(BuildContext context) {
    if (resultSinif != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Yerlesim Plani Bildirici"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.access_alarm),
              color: Colors.blueAccent,
              onPressed: () => print("click")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30),
                child: myTextItems("Öğrenci Adı", "${name}"),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: myTextItems("Sınıf", "${resultSinif}"),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: myTextItems("Koltuk", "${resultKoltuk}"),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Yerlesim Plani Bildirici"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.access_alarm),
              color: Colors.blueAccent,
              onPressed: () => print("click")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[],
          ),
        ),
      );
    }
  }

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
