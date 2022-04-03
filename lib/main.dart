import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms_app/home.dart';
import 'package:hrms_app/login.dart';
import 'navigatino_home_screen.dart';
import 'settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  AwesomeNotifications().initialize(null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'HRMS APP',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true)
      ]);
  runApp(
    EasyLocalization(
      fallbackLocale: Locale('ar', 'UAE'),
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'UAE')],
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
          home: MyHomePage(title: 'APP'),
          builder: EasyLoading.init(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Profile profile = Provider.of<Profile>(context, listen: false);

    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              // You can do some work here.
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Are your sure?"),
                  content: Text("you want to close the app"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("okay"),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              ); // Returning true allows the pop to happen, returning false prevents it.
              return true;
            },
            child: Scaffold(body: Container(child: Settings()))));
  }
}
