// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/views/gps_alert.dart';
import 'package:hrms_app/views/home.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/views/sos_tracking_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hrms_app/views/access_denied.dart';
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';
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

        MySharedPreferences.instance.setStringValue("id", id);

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

  Future<List<dynamic>> getSosHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    try {
      http.Response response = await _client.post(
          Uri.parse('http://lghrms.live/get-sos-history'),
          body: {"id": id});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return List<dynamic>.from(json['data']);
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("$e \nError while fetching sos history");
      }
      return [];
    }
  }

  Future<List<dynamic>> getSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final String date = formatter.format(now);
    try {
      http.Response response = await _client
          .post(Uri.parse('http://lghrms.live/get-session'), body: {
        "id": id,
        "date": date,
      });

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json['data'];
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("$e \nError while fetching sessions");
      }
      return [];
    }
  }

  Future<List<dynamic>> getAllSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    print(id);
    try {
      http.Response response = await _client
          .post(Uri.parse('http://lghrms.live/get-all-sessions'), body: {
        "id": id,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        return json['data'];
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("$e \nError while fetching sessions");
      }
      return [];
    }
  }

  Future<List<Map<String, Object>>> getSosData(sosid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    try {
      http.Response response = await _client.post(
          Uri.parse('http://lghrms.live/get-sos-data'),
          body: {"id": id, "sosid": sosid});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return List<Map<String, Object>>.from(json['data']);
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("$e \nError while fetching sos data");
      }
      return [];
    }
  }

  static submitSession(
      context, String loginSession, String time, String date, image) async {
    const String baseUrl = "https://lghrms.live/";

    var url = baseUrl + "add-session";

    MySharedPreferences.instance.getStringValue("id").then((id) async {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        "id": id,
        "login_session": loginSession,
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

      if (r.statusCode == 200) {
        await EasyLoading.showSuccess("Submitted Successfully");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
  }

  static submitLocationTracking(status) async {
    if (kDebugMode) {
      print("SUBMITTING NEW SESSION $status");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    try {
      http.Response response = await _client
          .post(Uri.parse('http://lghrms.live/add-geofence-log'), body: {
        "id": id,
        "date_time": getDateTime(),
        "status": status.toString()
      });
      if (response.statusCode == 200) {}
    } catch (e) {
      if (kDebugMode) {
        print(""""Couldn't add geofence log""");
        print(e);
      }
    }
  }

  static String getDateTime() {
    final DateTime now = DateTime.now();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat formatterTime = DateFormat('Hm');

    final String formatted = formatter.format(now);
    final String _formatterTime = formatterTime.format(now);
    return "$formatted $_formatterTime";
  }

  static startSosSession(context, location) async {
    showDialog(
        context: context,
        builder: (builder) {
          return Center(child: CircularProgressIndicator());
        });
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GpsAlert()));
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GpsAlert()));
      }
    }

    var sosid = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    try {
      Location currentLocation = Location();
      Future<LocationData> _location = currentLocation.getLocation();

      _location.then((value) async {
        http.Response response = await _client
            .post(Uri.parse('http://lghrms.live/start-sos-session'), body: {
          "id": id,
          "date_time": getDateTime(),
          "location": [value.latitude, value.longitude].join(",").toString()
        });

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          sosid = json['id'];
          await availableCameras().then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SosTrackingPage(
                  cameras: value,
                  sosid: sosid,
                ),
              )));
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(
            """"Couldn't start sos session-----------------------------------------------""");
        print(e);
      }
    }
  }

  static submitIncedent(context, subject, message, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    try {
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse('http://lghrms.live/add-incident'));
      request.fields.addAll({
        "id": id.toString(),
        "date_time": getDateTime(),
        "message": message,
        "subject": subject
      });
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image?.path,
          contentType: MediaType('application', 'jpeg'),
        ),
      );
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await EasyLoading.showSuccess("Submitted Successfully");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    } catch (e) {
      if (kDebugMode) {
        print(""""Couldn't add incident""");
        print(e);
      }
    }
  }

  static submitAudio(context, path, sosid) async {
    const String baseUrl = "https://lghrms.live/";

    var url = baseUrl + "add-audio";

    MySharedPreferences.instance.getStringValue("id").then((id) async {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll({
        "id": id,
        "sos_id": sosid,
        "_type": "_type",
        "date_time": "date + " " + time",
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'audiofile',
          path,
          contentType: MediaType('application', 'mp3'),
        ),
      );
      http.StreamedResponse r = await request.send();

      if (r.statusCode == 200) {
        await EasyLoading.showSuccess("Submitted Successfully");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        if (kDebugMode) {
          print(r.statusCode);
          print(r.toString());
          print("Something went wrong");
        }
      }
    });
  }

  static submitImage(context, image) async {
    const String baseUrl = "https://lghrms.live/";

    var url = baseUrl + "add-image";

    MySharedPreferences.instance.getStringValue("id").then((id) async {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        "id": id,
        "type": "image",
        "date_time": getDateTime(),
      });
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image?.path,
          contentType: MediaType('application', 'jpeg'),
        ),
      );
      http.StreamedResponse r = await request.send();

      if (r.statusCode == 200) {
        await EasyLoading.showSuccess("Submitted Successfully");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
  }
}
