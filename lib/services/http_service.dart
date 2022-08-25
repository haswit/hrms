// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/constants.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/views/home.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/views/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/login.dart';

class HttpService {
  static final _client = http.Client();

  static login(cin, username, password, context) async {
    final _loginUrl = Uri.parse('${ConstantStrings.baseUrl}/Login');

    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "cinNumber": cin,
      "userName": username,
      "password": password,
      "siteGeoLatitude": 1.10,
      "siteGeoLongitude": 1.10
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      _loginUrl,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    print("---------logging in -----$cin, $username, $password");

    var jsondata = jsonDecode(response.body);
    print(jsondata);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(jsondata);
      if (jsondata != null) {
        await EasyLoading.showSuccess("Logged In successfuly");
        // var user = json['user'];

        MySharedPreferences.instance.setStringValue("logged_in", "true");

        MySharedPreferences.instance
            .setStringValue("cin", jsondata['cinNumber'].toString());

        MySharedPreferences.instance
            .setStringValue("username", username.toString());

        MySharedPreferences.instance.setStringValue("pwd", password);

        MySharedPreferences.instance.setStringValue("token", jsondata['token']);

        MySharedPreferences.instance
            .setStringValue("id", jsondata['id'].toString());

        MySharedPreferences.instance
            .setDoubleValue("latitude", jsondata['siteGeoLatitude']);
        MySharedPreferences.instance
            .setDoubleValue("longitude", jsondata['siteGeoLongitude']);
        MySharedPreferences.instance
            .setDoubleValue("gain", checkDouble(jsondata['siteGeoGain']));
        MySharedPreferences.instance.setDoubleValue(
            "innerRadius", checkDouble(jsondata['innerRadius']));
        MySharedPreferences.instance.setDoubleValue(
            "outerRadius", checkDouble(jsondata['outerRadius']));

        MySharedPreferences.instance
            .setStringValue("siteName", jsondata['siteName']);
        MySharedPreferences.instance
            .setStringValue("siteNameAr", jsondata['siteNameAr']);

        // if (user['subscribed'] == false) {

        // if (false == false) {
        //   await Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const AccessDenied()));
        // } else {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
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

  static submitSession(
      context, String loginSession, String time, String date, image) async {
    var sessn = loginSession == "IN" ? "checkInEmpoyee" : "checkOutEmpoyee";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? inTime = "";

    var outTime = "";
    if (loginSession == "IN") {
      inTime = time;
      prefs.setString("inTime", time);
      outTime = time;
    } else {
      outTime = time;
      inTime = prefs.getString("inTime");
    }

    print("$inTime   $outTime $date");
    String url = "${ConstantStrings.baseUrl}/${sessn}";

    String token = prefs.getString("token").toString();

    var id = prefs.getString("id");
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      "id": id.toString(),
      "employeeId": "",
      "name": "-",
      "date": date,
      "inTime": inTime.toString(),
      "outTime": outTime,
      "attnFlag": loginSession,
      "shiftId": "0",
      "siteCode": "-",
      "shiftNumber": "0"
    });
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        image?.path,
        contentType: MediaType('application', 'jpeg'),
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse r = await request.send();
    print(r.statusCode);

    if (r.statusCode == 200) {
      await EasyLoading.showSuccess("Submitted Successfully");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      await EasyLoading.showError("Something went wrong!");
    }
  }

  static logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();

    String cin = prefs.getString("cin").toString();

    final url = Uri.parse('${ConstantStrings.baseUrl}/Logout');
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

      MySharedPreferences.instance.setStringValue("logged_in", "");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );

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
    String token = prefs.getString("token").toString();

    final url = Uri.parse('${ConstantStrings.baseUrl}/LocationTracking');

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

  static submitIncedent(context, subject, message, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");

    String token = prefs.getString("token").toString();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('${ConstantStrings.baseUrl}/incidentReport'),
      );

      request.fields.addAll({
        "description": message,
        "title": subject,
        "siteGeoLatitude": "1.10",
        "siteGeoLongitude": "1.10",
      });
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image?.path,
          contentType: MediaType('application', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        await EasyLoading.showSuccess("Submitted Successfully");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        print(response.statusCode);
        await EasyLoading.showError("Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        print(""""Couldn't add incident""");
        print(e);
      }
    }
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return 0.0 + value;
    } else {
      return value;
    }
  }

  Future<dynamic> getcheckInEmployee() async {
    String url =
        "${ConstantStrings.baseUrl}/checkInEmpoyee?page=0&PageCount=20&OrderBy=id";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(url);
    String token = prefs.getString("token").toString();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.statusCode);
    var responseData = json.decode(response.body);

    return responseData;
  }
}
