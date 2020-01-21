import 'dart:convert';

import 'package:flutter/material.dart';
import  'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  SocketIO socketIO;
  List<String> messages;

  @override
  void initState() {
    super.initState();

    //Initializing the message list
    messages = List<String>();

    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'http://10.0.2.2:5000',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();
    print("Data**********************dwq");
    //Subscribe to an event to listen to
    socketIO.subscribe('students_list', (jsonData) {
      //Convert the JSON data received into a Map
      var data = json.decode(jsonData);
      print(data[3]);
      for (var i = 0; i < data.length; i++) {
        this.setState(() => {
          messages.add(data[i]["ad"] + " - " + data[i]["sinif"] + " - " + data[i]["koltuk"])
        });
      }
      this.setState(() => messages.add(data[3]['sinif']));
      print("Data**********************");
    });

    //Connect to the socket
    socketIO.connect();
  }

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          messages[index],
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      height: 1000,
      width: 1000,
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yerlesim Plani Bildirici"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildMessageList(),
          ],
        ),
      ),
    );
  }

}
