import 'package:flutter/material.dart';

AppBar headerNav(String? title) {
  return AppBar(
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 31, 29, 29)),
    title: Text(
      title ?? "HRMS",
      style: const TextStyle(
          color: Color.fromARGB(227, 45, 41, 41),
          fontSize: 25,
          fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}
