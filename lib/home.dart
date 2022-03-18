import 'package:maps_toolkit/maps_toolkit.dart' as tk;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'camera.dart';
import 'package:camera/camera.dart';

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

    map_circle = LatLng(_center_x, 78.442633);
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
        InLoginZone = false;
      }

      setState(() {
        // _markers.add(Marker(
        //     markerId: MarkerId('Home'),
        //     position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

  late Set<Circle> circles;
  @override
  void initState() {
    super.initState();

    setState(() {
      getLocation();
      circles = Set.from([
        Circle(
            fillColor: Color.fromARGB(61, 33, 149, 243),
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
    return SafeArea(
        child: Scaffold(
            drawer: Drawer(),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.logout_sharp,
                    size: 28,
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
                                      ? () {
                                          Get.to(() => (CameraPage));
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
                                  child: Text("OUT",
                                      style: TextStyle(fontSize: 25)))),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 680,
                    child: GoogleMap(
                        minMaxZoomPreference: MinMaxZoomPreference(17, 100),
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
