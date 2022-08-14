// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:geofencing/geofencing.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/views/gps_alert.dart';
import 'package:hrms_app/views/home_screen.dart';
import 'package:hrms_app/views/login.dart';
import 'package:hrms_app/views/notifications.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';
import 'package:location/location.dart' as locationPakage;
import 'package:maps_toolkit/maps_toolkit.dart' as tk;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'HRMS APP',
            channelDescription: "Notification example",
            defaultColor: const Color(0XFF9050DD),
            ledColor: Colors.white,
            locked: true,
            playSound: true,
            enableLights: true,
            enableVibration: true)
      ]);
  runApp(
    EasyLocalization(
      fallbackLocale: const Locale('ar', 'UAE'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'UAE')],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Profile>(
            create: (final BuildContext context) {
              return Profile();
            },
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: MyHomePage(),
          builder: EasyLoading.init(),
        ));
  }
}

locationPakage.Location location = locationPakage.Location();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String geofenceState = 'N/A';
  List<String> registeredGeofences = [];
  double latitude = 1.10;
  double longitude = 1.10;
  double radius = 200;
  ReceivePort port = ReceivePort();
  // final List<GeofenceEvent> triggers = <GeofenceEvent>[
  //   GeofenceEvent.enter,
  //   GeofenceEvent.dwell,
  //   GeofenceEvent.exit
  // ];
  // final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
  //     initialTrigger: <GeofenceEvent>[
  //       GeofenceEvent.enter,
  //       GeofenceEvent.exit,
  //       GeofenceEvent.dwell
  //     ],
  //     loiteringDelay: 1000 * 60);

  bool isLoaded = false;
  bool languageSelected = false;
  bool isLoggedIn = false;

  late bool inLoginZone;

  bool userInRarius(l) {
    final distance = tk.SphericalUtil.computeDistanceBetween(
        tk.LatLng(latitude, longitude), l);
    return distance < radius;
  }

  cronJob() async {
    print('executing...');
    late final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    location.getLocation().then((value) {
      bool x = userInRarius(
          tk.LatLng(value.latitude!.toDouble(), value.longitude!.toDouble()));
      if (x) {
        print("User in Radius");
        setState(() {
          inLoginZone = true;
        });
      } else {
        print("User not in Radius");
        //NotifyUser("Please move into Login zone to enter the attendance");
        setState(() {
          inLoginZone = false;
        });
      }

      HttpService.submitLocationTracking(inLoginZone);
    });
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        latitude = prefs.getDouble('latitude')!;
        longitude = prefs.getDouble('longitude')!;

        radius = prefs.getDouble('outerRadius')!;
      });
    } catch (e) {}
    setState(() {
      isLoaded = true;
    });

    var selected = prefs.getString('_selectedLanguage');
    if (selected != "") {
      setState(() {
        languageSelected = true;
      });
    } else {
      setState(() {
        languageSelected = false;
      });
    }

    var loggedin = prefs.getString('logged_in');
    if (loggedin == "true") {
      setState(() {
        isLoggedIn = true;
      });
    }

    if (isLoggedIn) {
      final cron = Cron();
      cron.schedule(Schedule.parse('*/1 * * * *'), () async {
        // print('every three minutes');
        if (kDebugMode) {
          print("CRON EXECUTING");
        }
        cronJob();
      });
    }
  }

  String _notificationMsg = 'No Message';
  _changeMsg(String msg) {
    setState(() {
      _notificationMsg = msg;
      print(_notificationMsg);
    });
  }

  checkPermissions() async {
    bool _serviceEnabled;
    locationPakage.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GpsAlert()));
      } else {
        // initPlatformState();
        registerTracking();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locationPakage.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locationPakage.PermissionStatus.granted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GpsAlert()));
      } else {
        // initPlatformState();
        registerTracking();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // FCM firebaseMessaging = FCM();
    // firebaseMessaging.setNotifications();
    // firebaseMessaging.streamCtlr.stream.listen((msgData) {
    //   _changeMsg(msgData);
    // });

    print("=================port ${port.sendPort}======");
    IsolateNameServer.registerPortWithName(
        port.sendPort, 'geofencing_send_port');
    port.listen((dynamic data) {
      print('Event====================================: $data');
      setState(() {
        geofenceState = data;
      });
    });
    checkPermissions();
    getUser();
  }

  // static void callback(List<String> ids, Location l, GeofenceEvent e) async {
  //   print('Fences: $ids Location $l Event: $e');
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('geofencing_send_port');
  //   send?.send(e.toString());
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   print('Initializing...');
  //   await GeofencingManager.initialize();
  //   print('Initialization done');
  // }

  String? numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final num? a = num.tryParse(value);
    if (a == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  registerTracking() {
    if (latitude == null) {
      setState(() => latitude = 0.0);
    }
    if (longitude == null) {
      setState(() => longitude = 0.0);
    }
    if (radius == null) {
      setState(() => radius = 0.0);
    }
    // GeofencingManager.registerGeofence(
    //         GeofenceRegion('office1', latitude, longitude, radius, triggers,
    //             androidSettings: androidSettings),
    //         callback)
    //     .then((_) {
    //   GeofencingManager.getRegisteredGeofenceIds().then((value) {
    //     setState(() {
    //       registeredGeofences = value;
    //     });
    // });
    // });
  }

  // unRegisterTracking() {
  //   GeofencingManager.removeGeofenceById('office1').then((_) {
  //     GeofencingManager.getRegisteredGeofenceIds().then((value) {
  //       setState(() {
  //         registeredGeofences = value;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Center(child: const CircularProgressIndicator())
        : SafeArea(
            child: WillPopScope(
                onWillPop: () async {
                  // You can do some work here.
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Are your sure?"),
                      content: const Text("you want to close the app"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("okay"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ); // Returning true allows the pop to happen, returning false prevents it.
                  return true;
                },
                child: !languageSelected
                    ? const Settings()
                    : !isLoggedIn
                        ? const Login()
                        : const HomeScreen()));
  }
}
