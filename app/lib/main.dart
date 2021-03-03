import 'package:firebase_app/output.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      '/output': (context) => Output(),
    },
  ));
}

String cmd;
var op;
List outputs;
op_put(value) async {
  var url = "http://192.168.43.226/cgi-bin/exec.py?x=${value}";
  var r = await http.get(url);
  var data = r.body;
  var fbconnect = FirebaseFirestore.instance;
  fbconnect
      .collection("command")
      .add({'output': data, 'timestamp': Timestamp.now()});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  op_get() {
    Navigator.pushNamed(context, '/output');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  NetworkImage("https://wallpaperaccess.com/full/429385.jpg"),
              fit: BoxFit.fill),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'Linux Console',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 100, left: 40, right: 40, bottom: 40),
                child: TextField(
                  onChanged: (value) {
                    cmd = value;
                  },
                  //obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'command',
                  ),
                ),
              ),
              Container(
                child: Card(
                    child: FlatButton(
                        onPressed: () {
                          op_put(cmd);
                        },
                        child: Text('save output'))),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Card(
                  child: FlatButton(
                      onPressed: () {
                        op_get();
                      },
                      child: Text('Retrieve')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
