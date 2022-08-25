import 'package:flutter/foundation.dart';
import 'package:hrms_app/constants.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/views/gps_alert.dart';
import 'package:hrms_app/views/home_screen.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as tk;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../widgets/appbar.dart';
import 'camera.dart';
import 'package:camera/camera.dart';
import '../widgets/drawer.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart' as localization;

class Home extends StatefulWidget {
// /  final latitude = 17.391911;
//   final longitude = 78.442108;

  //final double latitude = 17.390689;

  final dynamic innerRadius;
  final dynamic outerRadius;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic gain;
  const Home(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.innerRadius,
      required this.outerRadius,
      required this.gain})
      : super(key: key);

  @override
  State<Home> createState() =>
      // ignore: no_logic_in_create_state
      _HomeState(latitude, longitude, innerRadius, outerRadius, gain);
}

class _HomeState extends State<Home> {
  late dynamic _latitude;
  late dynamic _longitude;
  late LatLng _center;
  late LatLng mapCircle;
  late dynamic _innerRadius;
  late dynamic _outerRadius;
  // ignore: unused_field
  late dynamic _gain;

  _HomeState(dynamic centerX, dynamic centerY, dynamic innerRadius,
      dynamic outerRadius, dynamic gain) {
    _latitude = centerX;
    _longitude = centerY;
    _innerRadius = innerRadius;
    _outerRadius = outerRadius;
    _center = LatLng(centerX, centerY);
    _gain = gain;
    mapCircle = LatLng(_latitude, _longitude);
  }

  Location currentLocation = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late GoogleMapController mapController;
  double _mapZoom = 1.0;

  var inLoginZone = true;
  double h = 1.0;
  // ignore: unused_field
  late LatLng _cameraPosition;
  final Set<Marker> _markers = {};
  late final SharedPreferences prefs;

  intSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    // BioAuth();
  }

  void logout(context) async {
    await prefs.setString('logged_in', "false");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getLocation() async {
    // currentLocation.enableBackgroundMode(enable: true);
    _serviceEnabled = await currentLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await currentLocation.requestService();

      if (!_serviceEnabled) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      }
    }

    _permissionGranted = await currentLocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await currentLocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsAlert()),
        );
      }
    }

    var location = await currentLocation.getLocation();

    currentLocation.onLocationChanged.listen((LocationData loc) async {
      mapController
          // ignore: unnecessary_new
          .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));

      setState(() {
        LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble());
        h = location.altitude!.toDouble();
      });

      bool x = userInRarius(
          tk.LatLng(loc.latitude!.toDouble(), loc.longitude!.toDouble()));
      if (x) {
        setState(() {
          inLoginZone = true;
        });
      } else {
        //NotifyUser("Please move into Login zone to enter the attendance");
        inLoginZone = false;
      }

      setState(() {
        _markers.add(Marker(
            markerId: const MarkerId('Office'),
            position: LatLng(_latitude, _latitude)));
      });
    });
  }

  late Set<Circle> circles;
  bool alreadyIn = false;
  @override
  void initState() {
    super.initState();

    intSharedPrefs();

    // var _sessionsData = HttpService().getSessions();
    // _sessionsData.then((value) {
    //   if (value.length > 1) {
    //     if (value[value.length - 1]['session'] == "IN") {
    //       setState(() {
    //         //alreadyIn = true;
    //       });
    //     }
    //   }
    // });

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    setState(() {
      getLocation();
      circles = {
        Circle(
            fillColor: const Color.fromARGB(76, 245, 133, 4),
            circleId: const CircleId("one"),
            center: mapCircle,
            radius: _outerRadius,
            strokeColor: const Color.fromARGB(0, 33, 149, 243)),
        Circle(
            fillColor: const Color.fromARGB(127, 4, 245, 16),
            circleId: const CircleId("one"),
            center: mapCircle,
            radius: _innerRadius,
            strokeColor: const Color.fromARGB(0, 33, 149, 243)),
      };
    });
  }

  bool userInRarius(l) {
    final distance = tk.SphericalUtil.computeDistanceBetween(
        tk.LatLng(widget.latitude, widget.longitude), l);

    return distance < widget.innerRadius;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.locale = Locale('ar', 'UAE');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "AppStrings.attendance".tr(),
              style: TextStyle(color: ConstantStrings.kPrimaryColor),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.chevron_left,
                color: ConstantStrings.kPrimaryColor,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: WillPopScope(
            onWillPop: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              return true;
            },
            child: Column(
              children: [
                Container(
                  child: SizedBox(
                    child: Stack(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.88,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: GoogleMap(
                              minMaxZoomPreference:
                                  const MinMaxZoomPreference(15, 1000),
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
                        ),
                      ),
                      HeaderButtons(
                          inLoginZone: inLoginZone, alreadyIn: alreadyIn),
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class HeaderButtons extends StatelessWidget {
  const HeaderButtons(
      {Key? key, required this.inLoginZone, required this.alreadyIn})
      : super(key: key);

  final bool inLoginZone;
  final bool alreadyIn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        child: Card(
          shadowColor: Colors.white,
          elevation: 4,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                OutOfRadiusMessage(
                  inLoginZone: inLoginZone,
                ),
                LoginButtons(inLoginZone: inLoginZone, alreadyIn: alreadyIn),
                const SizedBox(height: 10),
                const RadiusInfoChips(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadiusInfoChips extends StatelessWidget {
  const RadiusInfoChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, left: 20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(167, 27, 202, 65),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 20,
              width: 20,
            ),
            Text("AppStrings.loginZone".tr()),
            const SizedBox(
              width: 20,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, left: 20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(131, 244, 132, 3),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 20,
              width: 20,
            ),
            Text("AppStrings.officeZone".tr())
          ],
        )
      ],
    );
  }
}

class LoginButtons extends StatelessWidget {
  const LoginButtons(
      {Key? key, required this.inLoginZone, required this.alreadyIn})
      : super(key: key);

  final bool inLoginZone;
  final bool alreadyIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.green,
                    primary: const Color.fromARGB(221, 27, 202, 65)),
                onPressed: inLoginZone
                    ? !alreadyIn
                        ? () async {
                            await availableCameras()
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraPage(
                                        session: "IN",
                                        cameras: value,
                                      ),
                                    )));
                          }
                        : null
                    : null,
                child: Text(
                  "AppStrings.checkIn".tr(),
                  style: TextStyle(fontSize: 25),
                ))),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(226, 244, 67, 54)),
                onPressed:
                    // inLoginZone
                    //     ? !alreadyIn
                    // ?
                    () async {
                  await availableCameras().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(
                          session: "OUT",
                          cameras: value,
                        ),
                      )));
                }
                //     : null
                // : null
                ,
                child: Text("AppStrings.checkOut".tr(),
                    style: TextStyle(fontSize: 25)))),
      ]),
    );
  }
}

class OutOfRadiusMessage extends StatelessWidget {
  final bool inLoginZone;
  const OutOfRadiusMessage({Key? key, required this.inLoginZone})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: inLoginZone ? false : true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(5),
        color: const Color.fromARGB(82, 244, 132, 3),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.info),
              ),
              Text(
                "AppStrings.locationWarning".tr().toString(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 7, 7, 7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
