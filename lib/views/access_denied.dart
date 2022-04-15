//import
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

//view
class AccessDenied extends StatelessWidget {
  const AccessDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: headerNav("ACCESS DENIED"),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: const Text(
                      "Your subscription has been expired",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 35,
                          fontFamily: "Calistoga"),
                    ),
                  ),
                ),
                Image.asset("assets/media/access_denied.png")
              ],
            )));
  }
}
