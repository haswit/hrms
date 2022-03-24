import 'dart:ui';
import 'package:hrms_app/settings.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as tk;
import 'package:get/get.dart' hide Trans;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'camera.dart';
import 'package:camera/camera.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart' as Loc;

class Home extends StatefulWidget {
// /  final center_x = 17.391911;
//   final center_y = 78.442108;

  //final double center_x = 17.390689;

  var locationRadius;
  var center_y;
  var center_x;

  Home({this.center_x, this.center_y, this.locationRadius});

  @override
  State<Home> createState() =>
      _HomeState(this.center_x, this.center_y, this.locationRadius);
}

class _HomeState extends State<Home> {
  var _center_x;
  var _center_y;
  var _center;
  var map_circle;
  var _locationRadius;

  _HomeState(double center_x, double center_y, double locationRadius) {
    this._center_x = center_x;
    this._center_y = center_y;
    this._locationRadius = _locationRadius;
    this._center = LatLng(center_x, center_y);

    map_circle = LatLng(_center_x, _center_y);
  }

  Location currentLocation = Location();
  late GoogleMapController mapController;
  double _mapZoom = 1.0;

  var InLoginZone = false;
  double h = 1.0;
  var _cameraPosition;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);

      setState(() {
        LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble());
        h = location.altitude!.toDouble();
      });

      bool x = userInRarius(
          tk.LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble()));
      if (x) {
        setState(() {
          InLoginZone = true;
        });
      } else {
        //NotifyUser("Please move into Login zone to enter the attendance");
        InLoginZone = false;
      }

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('Office'),
            position: LatLng(_center_x ?? 0.0, _center_x ?? 0.0)));
      });
    });
  }

  late Set<Circle> circles;

  NotifyUser(title) {
    Get.snackbar(
      title,
      "",
      icon: Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      getLocation();
      circles = Set.from([
        Circle(
            fillColor: Color.fromARGB(57, 4, 245, 16),
            circleId: CircleId("one"),
            center: map_circle,
            radius: 600.0,
            strokeColor: Color.fromARGB(0, 33, 149, 243)),
        Circle(
            fillColor: Color.fromARGB(136, 245, 133, 4),
            circleId: CircleId("one"),
            center: map_circle,
            radius: 200.0,
            strokeColor: Color.fromARGB(0, 33, 149, 243)),
      ]);
    });
  }

  bool userInRarius(l) {
    final distance = tk.SphericalUtil.computeDistanceBetween(
        tk.LatLng(widget.center_x, widget.center_y), l);

    return distance < widget.locationRadius;
  }

  @override
  Widget build(BuildContext context) {
    //context.locale = Locale('ar', 'UAE');

    return SafeArea(
        child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => (Settings()));
                    },
                    title: Text("Setting"),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => (Login()));
                    },
                    icon: Icon(Icons.logout_sharp, size: 28),
                  ),
                )
              ],
              title: Text(
                "HRMS APP",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color.fromARGB(255, 36, 14, 97),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Visibility(
                    visible: InLoginZone ? false : true,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(5),
                      color: Color.fromARGB(82, 244, 132, 3),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.info),
                            ),
                            Text(
                              "warning".tr().toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 7, 7, 7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.green,
                                      primary:
                                          Color.fromARGB(221, 27, 202, 65)),
                                  onPressed: InLoginZone
                                      ? () async {
                                          await availableCameras()
                                              .then((value) => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CameraPage(
                                                      cameras: value,
                                                    ),
                                                  )));
                                        }
                                      : null,
                                  child: Text(
                                    "IN",
                                    style: TextStyle(fontSize: 25),
                                  ))),
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(226, 244, 67, 54)),
                                  onPressed: 1 == 2 //InLoginZone
                                      ? () async {
                                          await availableCameras()
                                              .then((value) => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CameraPage(
                                                      cameras: value,
                                                    ),
                                                  )));
                                        }
                                      : null,
                                  child: Text("OUT",
                                      style: TextStyle(fontSize: 25)))),
                        ]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 20),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(131, 244, 132, 3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 20,
                            width: 20,
                          ),
                          Text("Login zone"),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 20),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(167, 27, 202, 65),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 20,
                            width: 20,
                          ),
                          Text("Office zone")
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 680,
                    child: GoogleMap(
                        minMaxZoomPreference: MinMaxZoomPreference(15, 1000),
                        zoomControlsEnabled: true,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        onMapCreated: _onMapCreated,
                        onCameraMove: (CameraPosition position) {
                          _cameraPosition = position.target;
                          _mapZoom = position.zoom;
                        },
                        markers: _markers,
                        circles: circles,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: _mapZoom,
                        )),
                  )
                ]),
              ),
            )));
  }
}
