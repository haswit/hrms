class Employee {
  final int _cin;
  String _id;
  double _latitude;
  double _longitude;
  double _gain;

  Employee(this._cin, this._id, this._latitude, this._longitude, this._gain);

  set id(String id) {
    this._id = id;
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

  int get cin => this._cin;
  String get id => this._id;
  double get latitude => this._latitude;
  double get longitude => this._longitude;
  double get gain => this._gain;
}
