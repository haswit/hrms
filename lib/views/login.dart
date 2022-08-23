// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hrms_app/constants.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:hrms_app/widgets/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../services/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var cin = "";
  late final String email;
  late SharedPreferences prefs;
  String pwd = "";
  String username = "";

  AuthService authProvider = AuthService();

  var _passwordVisible = false;

  authWithBio() {
    authProvider.bioAuth(cin, username, pwd, context);
  }

  initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var cin = prefs.getString("cin");
    if (cin.toString().isNotEmpty) {
      print("-------------------$cin");
      var username = prefs.getString("username");
      var pwd = prefs.getString("pwd");

      setState(() {
        cin = cin;
        username = username.toString();
        pwd = pwd;
        authProvider.bioAuth(cin, username, pwd, context);

        _cinController.text = cin!;
        _idController.text = username!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    initSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // IO.Socket socket = IO.io('http://localhost:5000', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'extraHeaders': {'foo': 'bar'} // optional
    // });

    // socket.onConnect((_) {
    //   socket.emit('msg', 'test');
    // });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 60, right: 20, left: 20),
                    child: SizedBox(
                        width: 400,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 182, 181, 194),
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Image.asset(
                                          "assets/media/logo-main.png"),
                                    )),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 18.0, right: 18.0),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: ConstantStrings.kPrimaryColor,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calistoga',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                              color: ConstantStrings
                                                  .kPrimaryColor
                                                  .withOpacity(0.3)),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 8.0),
                                                    child: Text(
                                                      "CIN Number",
                                                      style: TextStyle(
                                                          color: ConstantStrings
                                                              .kPrimaryColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  CustomInput(
                                                    validator: (value) {
                                                      if (value == "") {
                                                        return "Please Enter CIN";
                                                      }
                                                    },
                                                    controller: _cinController,
                                                    suffix: null,
                                                    showText: true,
                                                    hint: 'Enter CIN Number',
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15, bottom: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0),
                                                      child: Text(
                                                        "ID",
                                                        style: TextStyle(
                                                            color: ConstantStrings
                                                                .kPrimaryColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    CustomInput(
                                                      validator: (value) {
                                                        if (value == "") {
                                                          return "Please Enter ID";
                                                        }
                                                      },
                                                      controller: _idController,
                                                      suffix: null,
                                                      showText: true,
                                                      hint: 'Enter ID',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 8.0),
                                                    child: Text(
                                                      "Password",
                                                      style: TextStyle(
                                                          color: ConstantStrings
                                                              .kPrimaryColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  CustomInput(
                                                    validator: (value) {
                                                      if (value == "") {
                                                        return "Please Enter Password";
                                                      }
                                                    },
                                                    controller:
                                                        _passwordController,
                                                    suffix: IconButton(
                                                      icon: Icon(
                                                        // Based on passwordVisible state choose the icon
                                                        _passwordVisible
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Theme.of(context)
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
                                                    showText: _passwordVisible,
                                                    hint: 'Enter Password',
                                                  ),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),

                                                  //custom button

                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: CustomButton(
                                                        text: "Continue",
                                                        onclickFunction: () {
                                                          AuthService().authUser(
                                                              _cinController
                                                                  .text,
                                                              _idController
                                                                  .text,
                                                              _passwordController
                                                                  .text,
                                                              context);
                                                        }),
                                                  ),

                                                  const SizedBox(height: 50),
                                                  Visibility(
                                                    visible: cin != ""
                                                        ? true
                                                        : false,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          authWithBio();
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
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
                                                          children: [
                                                            CustomPaint(
                                                              foregroundPainter:
                                                                  BorderPainter(),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .fingerprint,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 70,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              '',
                                                              style: TextStyle(
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

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
