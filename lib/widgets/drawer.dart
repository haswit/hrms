import 'package:flutter/material.dart';
import 'package:hrms_app/services/auth.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:hrms_app/views/sos.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerItems = Container(
      decoration: BoxDecoration(color: Color(0xFF0098c2)),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(children: <Widget>[
              ListTile(
                title: Text(
                  'Language',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                leading: Icon(
                  Icons.language,
                  size: 20.0,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              ListTile(
                title: Text(
                  'Help',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                leading: Icon(
                  Icons.help,
                  size: 20.0,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) => Sos()));
                },
              ),
            ]),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                          title: Text(
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
                          trailing: Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                          )),
                    ],
                  ))),
        ],
      ),
    );
    return Drawer(child: drawerItems);
  }
}
