import 'package:flutter/material.dart';
import 'package:hrms_app/camera.dart';
import 'package:hrms_app/gps_alert.dart';
import 'package:hrms_app/homeScreen.dart';
import 'home.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:ui';
import 'services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/request_location.dart';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late final prefs;
  var cin = "";
  late final String email;

  var image1 = Image.asset("assets/media/bg2.jpg");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
  }

  intSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    var _cin = prefs.getString('cin');

    if (_cin != null) {
      setState(() {
        cin = _cin;
      });
      // BioAuth();
    }
  }

  var _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    setState(() {
      intSharedPrefs();
    });
  }

  BioAuth() async {
    bool isAuthenticated = await AuthService.authenticateUser();
    if (isAuthenticated) {
      Future<bool> location = request_location();

      if (location == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      } else {
        await prefs.setString('logged_in', "true");

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    center_x: 37.4220656,
                    center_y: 122.0862784,
                    locationRadius: 200.0,
                  )),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed.'),
        ),
      );
    }
  }

  AuthUser() async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.https('139.59.58.11', 'auth'),
          body: {'name': 'doodle', 'color': 'blue'});
      var decodedResponse =
          convert.jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }

    // await prefs.setString('cin', '123456456');

    // await prefs.setString('logged_in', "true");

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => Home(
    //             center_x: 37.4220656,
    //             center_y: 122.0862784,
    //             locationRadius: 200.0,
    //           )),
    // );
  }

  @override
  Widget build(BuildContext context) {
    IO.Socket socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });

    socket.onConnect((_) {
      socket.emit('msg', 'test');
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/media/bg2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(top: 150, right: 20, left: 20),
                    child: Container(
                        width: 400,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calistoga',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                          padding: EdgeInsets.all(25),
                                          decoration: new BoxDecoration(
                                              color: Colors.grey.shade200
                                                  .withOpacity(0.3)),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(
                                                        "CIN Number",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    CustomInput(
                                                      suffix: null,
                                                      showText: true,
                                                      hint: 'Enter CIN Number',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 15, bottom: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(
                                                        "Email",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    CustomInput(
                                                      suffix: null,
                                                      showText: true,
                                                      hint: 'Enter Email',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(
                                                        "Password",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    CustomInput(
                                                      suffix: IconButton(
                                                        icon: Icon(
                                                          // Based on passwordVisible state choose the icon
                                                          _passwordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark,
                                                        ),
                                                        onPressed: () {
                                                          // Update the state i.e. toogle the state of passwordVisible variable

                                                          setState(() {
                                                            _passwordVisible =
                                                                !_passwordVisible;
                                                          });
                                                        },
                                                      ),
                                                      showText:
                                                          _passwordVisible,
                                                      hint: 'Enter Password',
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50.0,
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          AuthUser();
                                                        },
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.0)),
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: Ink(
                                                          decoration:
                                                              BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xff374ABE),
                                                                      Color(
                                                                          0xff64B6FF)
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.7)),
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        50.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Continue",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 50),
                                                    Visibility(
                                                      visible: cin != ""
                                                          ? true
                                                          : false,
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            BioAuth();
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    0,
                                                                    33,
                                                                    149,
                                                                    243),
                                                            shadowColor:
                                                                const Color(
                                                                    0xFF323247),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .fingerprint,
                                                                color: Colors
                                                                    .white,
                                                                size: 70,
                                                              ),
                                                              Text(
                                                                '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  wordSpacing:
                                                                      1.2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )))
                            ])),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final hint;
  final showText;
  final suffix;
  const CustomInput({Key? key, this.hint, this.showText, this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: showText == true ? false : true,
      decoration: InputDecoration(
        suffixIcon: this.suffix,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(84, 49, 43, 110)),
          borderRadius: BorderRadius.circular(10.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(144, 255, 255, 255)),
          borderRadius: BorderRadius.circular(10.7),
        ),
        filled: true,
        fillColor: Color.fromARGB(144, 255, 255, 255),
        border: OutlineInputBorder(),
        hintText: this.hint,
      ),
    );
  }
}
