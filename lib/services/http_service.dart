import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrms_app/home.dart';
import 'package:hrms_app/settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hrms_app/home.dart';
import 'package:hrms_app/access_denied.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/models/profile.dart';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('http://lghrms.live/login');

  static login(cin, id, password, context, prefs) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "cin": cin,
      "id": id,
      "password": password,
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json["status"] == 'success') {
        await EasyLoading.showSuccess("Logged In successfuly");
        var user = json['user'];

        await prefs.setString('cin', user['cin']);

        await prefs.setString('logged_in', "true");

        final Profile profile = Provider.of<Profile>(context, listen: false);

        profile.cin = user['cin'];
        profile.id = user['id'];
        profile.inner_radius = user['inner_radius'];
        profile.outer_radius = user['outer_radius'];
        profile.gain = user['gain'];

        if (user['subscribed'] == false) {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccessDenied()));
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                    center_x: profile.latitude,
                    center_y: profile.longitude,
                    inner_radius: profile.inner_radius,
                    outer_radius: profile.inner_radius,
                    gain: profile.gain)),
          );
        }
      } else {
        EasyLoading.showError(json["status"]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }
}
