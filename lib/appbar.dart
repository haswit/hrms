import 'package:flutter/material.dart';

AppBar headerNav() {
  return AppBar(
    title: Text(
      "HRMS",
      style: TextStyle(
          color: Color.fromARGB(175, 0, 0, 0),
          fontSize: 25,
          fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
