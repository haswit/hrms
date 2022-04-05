// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/views/login.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/appbar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool multiple = true;

  var _selected = "UAE";
  var _countryCode = "ar";
  late SharedPreferences prefs;
  late String loggedin;

  intSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    var loggedIn = prefs.getString('logged_in');

    if (loggedIn != null) {
      setState(() {
        loggedin = loggedIn;
      });
      // BioAuth();
    }
  }

  @override
  void initState() {
    super.initState();
    intSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNav(),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Choose Language",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 28,
                      fontFamily: 'Calistoga'),
                ),
                const Text(
                  "you want to use the app in",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontFamily: 'Calistoga'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              //                                  context.setLocale(Locale('en', 'US'));

                              setState(() {
                                _selected = "US";
                                _countryCode = "en";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: _selected == "US"
                                      ? [
                                          const BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 5.0,
                                          ),
                                        ]
                                      : null,
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              width: 130,
                              alignment: Alignment.center,
                              height: 200,
                              padding: const EdgeInsets.all(20),

                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                        "assets/media/us-flag-shine.png"),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              //  context..setLocale(Locale('ar', 'UAE'));
                              setState(() {
                                _selected = "UAE";
                                _countryCode = "ar";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: _selected == "UAE"
                                      ? [
                                          const BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 5.0,
                                          ),
                                        ]
                                      : [
                                          const BoxShadow(
                                            color:
                                                Color.fromARGB(6, 68, 137, 255),
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              width: 130,
                              alignment: Alignment.center,
                              height: 200,
                              padding: const EdgeInsets.all(20),

                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                        "assets/media/uae-flag-shine.png"),
                                    Text(
                                      "Arabic",
                                      style: TextStyle(
                                          color: _selected == "UAE"
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  ]),
                              // Container
                            )),
                      )
                    ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomButton(
                      onclickFunction: () {
                        context.setLocale(Locale(_countryCode, _selected));
                        MySharedPreferences.instance
                            .setStringValue("_countryCode", _countryCode);
                        MySharedPreferences.instance
                            .setStringValue("_selectedLanguage", _selected);

                        if (loggedin == "1") {
                          Navigator.pop(context);
                          try {
                            Navigator.pop(context);
                            // ignore: empty_catches
                          } catch (e) {}
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        }
                      },
                      text: "Continue"),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            )),
      ),
    );

    // GesureDetector
  }
}
