import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Output extends StatefulWidget {
  @override
  _OutputState createState() => _OutputState();
}

class _OutputState extends State<Output> {
  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('OUTPUT'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                var msg = snapshot.data.docs;
                List y = [];

                for (var d in msg) {
                  var time = d.data()['timestamp'];
                  var msgText = d.data()['output'];
                  var msgwidget = Text('output: \n$msgText');
                  y.add(msgwidget);
                }

                return Container(
                  color: Colors.black,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: y.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.green[300],
                          child: ListTile(
                            title: y[index],
                          ),
                        );
                      }),
                );
              },
              stream: db.collection("command").orderBy("timestamp").snapshots(),
            ),
          ),
        ],
      ),
    );
  }
}
