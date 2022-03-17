import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;

  Location currentLocation = Location();

  Set<Marker> _markers = {};

  final LatLng _center = const LatLng(45.521563, -122.677433);

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
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));

        print("Data===========================================");
        print(_markers);
      });
    });
  }

  Set<Circle> circles = Set.from([
    Circle(
        fillColor: Color.fromARGB(61, 33, 149, 243),
        circleId: CircleId("one"),
        center: LatLng(17.385044, 78.486671),
        radius: 2000,
        strokeColor: Color.fromARGB(0, 33, 149, 243)),
  ]);

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
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
              title: Text("HRMS"),
              backgroundColor: Colors.blue,
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
                                  onPressed: () {},
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
                                  onPressed: () {},
                                  child: Text("OUT",
                                      style: TextStyle(fontSize: 25)))),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 680,
                    child: GoogleMap(
                        zoomControlsEnabled: true,
                        onMapCreated: _onMapCreated,
                        onCameraMove: null,
                        markers: _markers,
                        circles: circles,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 1.0,
                        )),
                  )
                ]),
              ),
            )));
  }
}
