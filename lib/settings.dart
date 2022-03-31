import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var _country_code = "ar";
  late final prefs;
  var loggedin;

  intSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    var logged_in = prefs.getString('logged_in');

    if (logged_in != null) {
      setState(() {
        loggedin = logged_in;
      });
      // BioAuth();
    }
  }

  var _passwordVisible = false;

  // @override
  // void initState() {
  //   _passwordVisible = false;
  //   setState(() {
  //     intSharedPrefs();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Choose Language",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 28,
                  fontFamily: 'Calistoga'),
            ),
            Text(
              "you want to use the app in",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontFamily: 'Calistoga'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () async {
//                                  context.setLocale(Locale('en', 'US'));

                            setState(() {
                              _selected = "US";
                              _country_code = "en";
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
                            height: 200,
                            padding: EdgeInsets.all(20),

                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset("assets/media/us-flag-shine.png"),
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
                              _country_code = "ar";
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
                                    : [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(6, 68, 137, 255),
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                border: Border.all(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            width: MediaQuery.of(context).size.width * 0.3,
                            alignment: Alignment.center,
                            height: 200,
                            padding: EdgeInsets.all(20),

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
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  context.setLocale(Locale(_country_code, _selected));

                  if (loggedin == "1") {
                    Navigator.pop(context);
                    try {
                      Navigator.pop(context);
                    } catch (e) {}
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }
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
            SizedBox(
              height: 20,
            )
          ],
        ));
    // GesureDetector
  }
}
