import 'package:flutter/material.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/services/auth.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:hrms_app/views/sos.dart';

import '../views/login.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerItems = Container(
      decoration: const BoxDecoration(color: Color(0xFF0098c2)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(children: <Widget>[
              ListTile(
                title: const Text(
                  'Attendance',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                leading: const Icon(
                  Icons.location_pin,
                  size: 20.0,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                },
              ),
              ListTile(
                title: const Text(
                  'Language',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                leading: const Icon(
                  Icons.language,
                  size: 20.0,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Settings()));
                },
              ),
              ListTile(
                title: const Text(
                  'Help',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                leading: const Icon(
                  Icons.help,
                  size: 20.0,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Sos()));
                },
              ),
            ]),
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                      title: const Text(
                        'Signout',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onTap: () {
                        var authProvider = AuthService();
                        authProvider.logout(context);
                      },
                      trailing: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      )),
                ],
              )),
        ],
      ),
    );
    return Drawer(child: drawerItems);
  }
}
