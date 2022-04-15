import 'package:cron/cron.dart';
import 'package:flutter/foundation.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/views/gps_alert.dart';
import 'package:hrms_app/views/notifications.dart';
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

  final double innerRadius;
  final double outerRadius;
  final double longitude;
  final double latitude;
  final double gain;
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
  late double _latitude;
  late double _longitude;
  late LatLng _center;
  late LatLng mapCircle;
  late double _innerRadius;
  late double _outerRadius;
  // ignore: unused_field
  late double _gain;

  _HomeState(double centerX, double centerY, double innerRadius,
      double outerRadius, double gain) {
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

  var inLoginZone = false;
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

    final cron = Cron();
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      // print('every three minutes');
      if (kDebugMode) {
        print("CRON EXECUTING");
      }
      if (!prefs.containsKey("inLoginZone")) {
        prefs.setBool("inLoginZone", inLoginZone);

        HttpService.submitLocationTracking(inLoginZone);
      } else {
        if (prefs.getBool("inLoginZone") != inLoginZone) {
          prefs.setBool("inLoginZone", inLoginZone);
          HttpService.submitLocationTracking(inLoginZone);
          if (!inLoginZone) {
            createNotification("Please move into login zone",
                "Logging out session in 3 minutes");
          }
        }
      }
    });

    var _sessionsData = HttpService().getSessions();
    _sessionsData.then((value) {
      print(
          "\n\n\n\n\n============================================\ndata has been fethed");
      if (value.length > 1) {
        print(value[value.length - 1]['session']);

        if (value[value.length - 1]['session'] == "IN") {
          setState(() {
            //alreadyIn = true;
          });
        }
      }
    });

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
            fillColor: Color.fromARGB(76, 245, 133, 4),
            circleId: const CircleId("one"),
            center: mapCircle,
            radius: _outerRadius,
            strokeColor: const Color.fromARGB(0, 33, 149, 243)),
        Circle(
            fillColor: Color.fromARGB(127, 4, 245, 16),
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

  bottomModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text("Todays sessions"),
                ),
                SizedBox(
                  height: 700,
                  child: FutureBuilder(
                    future: HttpService().getSessions(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        // if (snapshot.data[snapshot.data.length - 1]
                        //         ['session'] ==
                        //     "IN") {
                        //   alreadyIn = true;
                        // }

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(),
                                child: ListTile(
                                  trailing: const Icon(
                                    Icons.photo,
                                    color: Colors.blue,
                                  ),
                                  title: Text(snapshot.data[index]['session']),
                                  subtitle:
                                      Text(snapshot.data[index]['date_time']),
                                  leading: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        color: snapshot.data[index]
                                                    ['session'] ==
                                                "IN"
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //context.locale = Locale('ar', 'UAE');

    return SafeArea(
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.arrow_upward_sharp),
        //   onPressed: () {
        //     bottomModalSheet();
        //   },
        // ),
        appBar: headerNav("ATTENDANCE"),
        drawer: const MyDrawer(),
        body: Container(
          color: Colors.white,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.74,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 25,
                      left: 25,
                      top: MediaQuery.of(context).size.height * 0.18),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
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
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.30,
                    minChildSize: 0.15,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: const CustomScrollViewContent(),
                      );
                    },
                  ),
                ),
              ),
              HeaderButtons(inLoginZone: inLoginZone, alreadyIn: alreadyIn),
            ]),
          ),
        ),
      ),
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
      width: MediaQuery.of(context).size.width,
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
            const Text("Login zone"),
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
            const Text("Office zone")
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
                child: const Text(
                  "IN",
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
                onPressed: inLoginZone
                    ? !alreadyIn
                        ? () async {
                            await availableCameras()
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraPage(
                                        session: "OUT",
                                        cameras: value,
                                      ),
                                    )));
                          }
                        : null
                    : null,
                child: const Text("OUT", style: TextStyle(fontSize: 25)))),
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
                "warning".tr().toString(),
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

/// Content of the DraggableBottomSheet's child SingleChildScrollView
class CustomScrollViewContent extends StatelessWidget {
  const CustomScrollViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: const CustomInnerContent(),
      ),
    );
  }
}

class CustomInnerContent extends StatelessWidget {
  const CustomInnerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        SizedBox(height: 12),
        CustomDraggingHandle(),
        SizedBox(height: 16),
        MySitesTitle(),
        SizedBox(height: 16),
        MySites(),
        SizedBox(height: 24),
        SessionList(),
        SizedBox(height: 16),
        TodaysSessionsListView(),
        SizedBox(height: 24),
      ],
    );
  }
}

class CustomDraggingHandle extends StatelessWidget {
  const CustomDraggingHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class MySitesTitle extends StatelessWidget {
  const MySitesTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("My Sites",
            style: TextStyle(fontSize: 22, color: Colors.black45)),
        const SizedBox(width: 8),
        Container(
          height: 30,
          width: 30,
          child: const Icon(Icons.map, size: 12, color: Colors.black54),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }
}

class MySites extends StatelessWidget {
  const MySites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            CustomSiteChip(
              title: "Site A",
            ),
            SizedBox(width: 12),
            CustomSiteChip(
              title: "Site B",
            ),
          ],
        ),
      ),
    );
  }
}

class SessionList extends StatelessWidget {
  const SessionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44),
      //only to left align the text
      child: Row(
        children: const <Widget>[
          Text("Today's sessions", style: TextStyle(fontSize: 14))
        ],
      ),
    );
  }
}

class TodaysSessionsListView extends StatefulWidget {
  const TodaysSessionsListView({Key? key}) : super(key: key);

  @override
  State<TodaysSessionsListView> createState() => _TodaysSessionsListViewState();
}

class _TodaysSessionsListViewState extends State<TodaysSessionsListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
          child: FutureBuilder(
            future: HttpService().getSessions(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // if (snapshot.data[snapshot.data.length - 1]
                //         ['session'] ==
                //     "IN") {
                //   alreadyIn = true;
                // }

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: .2, color: Colors.lightBlue.shade900),
                          ),
                        ),
                        child: ListTile(
                          title: Text(snapshot.data[index]['session']),
                          subtitle: Text(snapshot.data[index]['date_time']),
                          leading: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                color: snapshot.data[index]['session'] == "IN"
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomSiteChip extends StatelessWidget {
  final String title;

  const CustomSiteChip({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          color: const Color.fromARGB(40, 33, 149, 243),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.pin_drop),
              onPressed: () {},
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ));
  }
}

class CustomFeaturedItem extends StatelessWidget {
  const CustomFeaturedItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text("Test"),
    );
  }
}
