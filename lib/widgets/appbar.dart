import 'package:flutter/material.dart';

AppBar headerNav(String? title) {
  return AppBar(
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
    title: Text(
      title ?? "HRMS",
      style: const TextStyle(
          color: Color.fromARGB(228, 255, 255, 255),
          fontSize: 25,
          fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    backgroundColor: const Color(0xFF0098c2),
  );
}
