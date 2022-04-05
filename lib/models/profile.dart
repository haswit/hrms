// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  bool _isAuthentificated = false;
  bool _loggedin = false;
  late int cin;
  late String id;
  late double latitude;
  late double longitude;
  late double gain;
  late double innerRadius;
  late double outerRadius;

  bool get isAuthentificated {
    return _isAuthentificated;
  }

  set isAuthentificated(bool newVal) {
    _isAuthentificated = newVal;
    notifyListeners();
  }

  bool get loggedin {
    return _loggedin;
  }

  set loggedin(bool newVal) {
    _loggedin = newVal;
    notifyListeners();
  }
}
