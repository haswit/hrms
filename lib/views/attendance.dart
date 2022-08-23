import 'package:flutter/material.dart';
import 'package:hrms_app/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late dynamic latitude;
  late dynamic longitude;
  late dynamic gain;
  late dynamic innerRadius;
  late dynamic outerRadius;
  bool loaded = false;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('latitude');
      longitude = prefs.getDouble('longitude');
      gain = prefs.getDouble('gain');
      innerRadius = prefs.getDouble('innerRadius');
      outerRadius = prefs.getDouble('outerRadius');
      loaded = true;

      print(
          "---loaded, $latitude, $longitude, $gain, $innerRadius, $outerRadius");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded == false
        ? const Center(child: CircularProgressIndicator())
        : Home(
            latitude: latitude,
            longitude: longitude,
            gain: gain,
            innerRadius: innerRadius,
            outerRadius: outerRadius,
          );
  }
}
