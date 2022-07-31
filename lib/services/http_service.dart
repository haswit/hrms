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

import '../views/login.dart';

class HttpService {
  static final _client = http.Client();

  // static final _loginUrl = Uri.parse('http://20.68.125.92/ErpMob/api/Login');
  //  request.headers.set('Content-type', 'application/json');

  static login(cin, id, password, context) async {
    final _loginUrl = Uri.parse('http://20.68.125.92/ErpMob/api/Login');

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "cinNumber": cin,
      "userName": id,
      "password": password,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      _loginUrl,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    print("$cin, $id, $password");
    // http.Response response = await _client.post(_loginUrl,
    //     headers: {"Content-type": "application/json"},
    //     body: jsonEncode(<String, dynamic>{
    //       "cinNumber": cin,
    //       "userName": id,
    //       "password": password,
    //     }.toString()));
    var jsondata = jsonDecode(response.body);
    print(jsondata);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(json);
      if (jsondata["status"] != false) {
        await EasyLoading.showSuccess("Logged In successfuly");
        // var user = json['user'];

        MySharedPreferences.instance.setStringValue("logged_in", "true");
        MySharedPreferences.instance
            .setStringValue("cin", jsondata['cinNumber'].toString());
        MySharedPreferences.instance.setStringValue("token", jsondata['token']);

        MySharedPreferences.instance.setStringValue("id", id);

        MySharedPreferences.instance
            .setDoubleValue("latitude", jsondata['siteGeoLatitude']);
        MySharedPreferences.instance
            .setDoubleValue("longitude", jsondata['siteGeoLongitude']);
        MySharedPreferences.instance
            .setDoubleValue("gain", jsondata['siteGeoGain']);
        MySharedPreferences.instance.setDoubleValue("innerRadius", 200.0);
        MySharedPreferences.instance.setDoubleValue("outerRadius", 400.0);

        // final Profile profile = Provider.of<Profile>(context, listen: false);
        // profile.cin = user['cin'];
        // profile.id = user['id'];
        // profile.innerRadius = user['inner_radius'];
        // profile.outerRadius = user['outer_radius'];
        // profile.latitude = user['latitude'];
        // profile.longitude = user['longitude'];
        // profile.gain = user['gain'];
        // print(profile.innerRadius);

        // if (user['subscribed'] == false) {

        // if (false == false) {
        //   await Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const AccessDenied()));
        // } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    latitude: jsondata['siteGeoLatitude'],
                    longitude: jsondata['siteGeoLongitude'],
                    gain: jsondata['siteGeoGain'],
                    innerRadius: 200,
                    outerRadius: 400,
                  )),
        );
        // }
      } else {
        EasyLoading.showError(jsondata["status"]);
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

  static logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token").toString();

    String cin = await prefs.getString("cin").toString();

    final url = Uri.parse('http://20.68.125.92/ErpMob/api/Logout');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> body = {"cinNumber": cin};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      if (response.statusCode == 200) {
        MySharedPreferences.instance.setStringValue("logged_in", "");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  static submitLocationTracking(status) async {
    if (kDebugMode) {
      print("SUBMITTING NEW SESSION $status");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token").toString();

    final url = Uri.parse('http://20.68.125.92/ErpMob/api/CheckGeoLocation');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> body = {
      "siteGeoLatitude": 1.10,
      "siteGeoLongitude": 1.10,
      "siteGeoGain": 1.10
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      print(response.statusCode);
      print(response.body);

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
        "_type": "audio",
        "date_time": getDateTime()
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

  static submitMessage(context, message, sosid) async {
    const String baseUrl = "https://lghrms.live/";

    var url = baseUrl + "add-message";

    MySharedPreferences.instance.getStringValue("id").then((id) async {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll({
        "id": id,
        "sos_id": sosid,
        "_type": "message",
        "message": message,
        "date_time": getDateTime(),
      });

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
