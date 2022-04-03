// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  bool _isAuthentificated = false;
  bool _loggedin = false;
  late int _cin;
  late String _id;
  late double _latitude;
  late double _longitude;
  late double _gain;
  late double _inner_radius;
  late double _outer_radius;

  bool get isAuthentificated {
    return this._isAuthentificated;
  }

  set isAuthentificated(bool newVal) {
    this._isAuthentificated = newVal;
    this.notifyListeners();
  }

  bool get loggedin {
    return this._loggedin;
  }

  set loggedin(bool newVal) {
    this._loggedin = newVal;
    this.notifyListeners();
  }

  set id(String id) {
    this._id = id;
  }

  set cin(int cin) {
    this._cin = cin;
  }

  set latitude(double latitude) {
    this._latitude = latitude;
  }

  set longitude(double longitude) {
    this._longitude = longitude;
  }

  set gain(double gain) {
    this._gain = gain;
  }

  set inner_radius(double radius) {
    this._inner_radius = radius;
  }

  set outer_radius(double radius) {
    this._outer_radius = radius;
  }

  int get cin => this._cin;
  String get id => this._id;
  double get latitude => this._latitude;
  double get longitude => this._longitude;
  double get gain => this._gain;
  double get inner_radius => this._inner_radius;
  double get outer_radius => this._outer_radius;
}
