import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/views/home.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hrms_app/views/access_denied.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static final _client = http.Client();

  static final _loginUrl = Uri.parse('http://lghrms.live/login');

  static login(cin, id, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "cin": cin,
      "id": id,
      "password": password,
    });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      if (json["status"] == 'success') {
        await EasyLoading.showSuccess("Logged In successfuly");
        var user = json['user'];

        MySharedPreferences.instance.setStringValue("logged_in", "true");
        MySharedPreferences.instance
            .setStringValue("cin", user['cin'].toString());

        MySharedPreferences.instance
            .setDoubleValue("latitude", user['latitude']);
        MySharedPreferences.instance
            .setDoubleValue("longitude", user['longitude']);
        MySharedPreferences.instance.setDoubleValue("gain", user['gain']);
        MySharedPreferences.instance
            .setDoubleValue("innerRadius", user['inner_radius']);
        MySharedPreferences.instance
            .setDoubleValue("outerRadius", user['outer_radius']);
        MySharedPreferences.instance.setStringValue("id", user['id']);

        // final Profile profile = Provider.of<Profile>(context, listen: false);
        // profile.cin = user['cin'];
        // profile.id = user['id'];
        // profile.innerRadius = user['inner_radius'];
        // profile.outerRadius = user['outer_radius'];
        // profile.latitude = user['latitude'];
        // profile.longitude = user['longitude'];
        // profile.gain = user['gain'];
        // print(profile.innerRadius);

        if (user['subscribed'] == false) {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AccessDenied()));
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      latitude: user['latitude'],
                      longitude: user['longitude'],
                      gain: user['gain'],
                      innerRadius: user['inner_radius'],
                      outerRadius: user['outer_radius'],
                    )),
          );
        }
      } else {
        EasyLoading.showError(json["status"]);
      }
    } else {
      //print("${response.statusCode.toString()}");
      await EasyLoading.showError("Something went wrong!");
    }
  }

  Future<List<dynamic>> getSessions() async {
    var data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final String date = formatter.format(now);

    http.Response response =
        await _client.post(Uri.parse('http://lghrms.live/get-session'), body: {
      "id": id,
      "date": date,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json['data'];
    } else {
      return [];
    }
  }

  static submitSession(
      context, String login_session, String time, String date, image) async {
    final String baseUrl = "https://lghrms.live/";

    var url = baseUrl + "add-session";

    MySharedPreferences.instance.getStringValue("id").then((id) async {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        "id": id,
        "login_session": login_session,
        "date_time": date + " " + time,
      });
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image?.path,
          contentType: MediaType('application', 'jpeg'),
        ),
      );
      http.StreamedResponse r = await request.send();
      print(r.statusCode);
      print("===================${r.statusCode}");

      if (r.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
  }
}
