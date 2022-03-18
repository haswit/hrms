import 'package:flutter/material.dart';

class Uploadtest extends StatefulWidget {
  const Uploadtest({Key? key}) : super(key: key);

  @override
  _UploadtestState createState() => _UploadtestState();
}

class _UploadtestState extends State<Uploadtest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [Icon(Icons.send, color: Colors.black)],
          leading: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            "Instagram",
            style: TextStyle(color: Colors.black),
          ))),
      drawer: Drawer(),
      body: Center(
          child: Column(
        children: [],
      )),
    );
  }
}
