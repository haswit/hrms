import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/views/home.dart';
import 'package:hrms_app/views/login.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';
import 'package:cron/cron.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'HRMS APP',
            channelDescription: "Notification example",
            defaultColor: const Color(0XFF9050DD),
            ledColor: Colors.white,
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
          home: const MyHomePage(),
          builder: EasyLoading.init(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;
  bool languageSelected = false;
  bool isLoggedIn = false;

  late final double? latitude;
  late final double? longitude;
  late final double? gain;
  late final double? innerRadius;
  late final double? outerRadius;

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('latitude');
      longitude = prefs.getDouble('longitude');
      gain = prefs.getDouble('gain');
      innerRadius = prefs.getDouble('innerRadius');
      outerRadius = prefs.getDouble('outerRadius');
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

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Center(
            child: CircularProgressIndicator(),
          )
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
                        : Home(
                            latitude: latitude!,
                            longitude: longitude!,
                            gain: gain!,
                            innerRadius: innerRadius!,
                            outerRadius: outerRadius!,
                          )));
  }
}
