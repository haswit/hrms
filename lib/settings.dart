import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/login.dart';
import 'package:get/get.dart' hide Trans;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // static void restartApp(BuildContext context) {
  //   context.findAncestorStateOfType<_SettingsState>().restartApp();
  // }

  var _selected = "UAE";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              padding: EdgeInsets.only(bottom: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Choose Your Language",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 28,
                        fontFamily: 'Calistoga'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              context.locale = Locale('en', 'US');
                              setState(() {
                                _selected = "US";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: _selected == "US"
                                      ? [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 5.0,
                                          ),
                                        ]
                                      : null,
                                  border: Border.all(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: MediaQuery.of(context).size.width * 0.3,
                              alignment: Alignment.center,
                              height: 100,
                              padding: EdgeInsets.all(20),

                              child: Column(children: [
                                Text(
                                  "En",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: _selected == "US"
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  "English",
                                  style: TextStyle(
                                      color: _selected == "US"
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ]),
                              // Container
                            )),
                        GestureDetector(
                            onTap: () async {
                              context.locale = Locale('ar', 'UAE');
                              setState(() {
                                _selected = "UAE";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: _selected == "UAE"
                                      ? [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 5.0,
                                          ),
                                        ]
                                      : null,
                                  border: Border.all(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: MediaQuery.of(context).size.width * 0.3,
                              alignment: Alignment.center,
                              height: 100,
                              padding: EdgeInsets.all(20),

                              child: Column(children: [
                                Text(
                                  "Ar",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: _selected == "UAE"
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  "Arabic",
                                  style: TextStyle(
                                      color: _selected == "UAE"
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ]),
                              // Container
                            ))
                      ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        Get.to(() => (Login()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10.7)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))),
    ); // GestureDetector
  }
}
