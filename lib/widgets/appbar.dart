import 'package:flutter/material.dart';

AppBar headerNav() {
  return AppBar(
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
    title: const Text(
      "HRMS",
      style: TextStyle(
          color: Color.fromARGB(228, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    backgroundColor: const Color(0xFF0098c2),
  );
}
