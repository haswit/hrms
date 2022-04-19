import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/views/activities.dart';
import 'package:hrms_app/views/attendance.dart';
import 'package:hrms_app/views/notification_screen.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:hrms_app/views/sos.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hrms_app/views/submit_incedent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user_id = "";

  // ignore: unnecessary_new
  Items item3 = new Items(
      title: "Attendance",
      subtitle: "Add IN - OUT entries",
      img: "assets/media/map.png",
      event: "",
      onclickWidget: const Attendance());

  Items item4 = Items(
      title: "Activity",
      subtitle: "Attendance Log",
      img: "assets/media/activities.png",
      event: "",
      onclickWidget: Activities());

  Items item5 = Items(
      title: "Emergency",
      subtitle: "Reach out for help",
      img: "assets/media/sos.png",
      event: "",
      onclickWidget: const Sos());

  Items item6 = Items(
      title: "Settings",
      subtitle: "Change language",
      img: "assets/media/setting.png",
      event: "",
      onclickWidget: const Settings());

  Items item7 = Items(
      title: "Report Incedent",
      subtitle: "Submit an incedent",
      img: "assets/media/info.png",
      event: "",
      onclickWidget: SubmitIncedent());

  Items item8 = Items(
      title: "Notifications",
      subtitle: "Check out notifications",
      img: "assets/media/notification.png",
      event: "3 notifications",
      onclickWidget: const NotificationScreen());

  @override
  void initState() {
    super.initState();

    MySharedPreferences.instance.getStringValue("id").then((value) {
      setState(() {
        user_id = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item3, item4, item7, item6, item8, item5];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 39, 41),
        title: const Text("Home"),
        elevation: 5,
        actions: const [
          Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: user_id == ""
          ? Container(
              height: double.infinity,
              color: const Color.fromARGB(255, 219, 192, 158),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )))
          : SingleChildScrollView(
              child: WillPopScope(
                onWillPop: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Are your sure?"),
                      content: const Text("you want to close the app"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text("okay"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ); // Returning true allows the pop to happen, returning false prevents it.

                  return true;
                },
                child: SizedBox(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(255, 219, 192, 158),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        ListTile(
                          title: const Text(
                            "Welcome Back",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontFamily: 'Calistoga'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, top: 5, right: 5),
                            child: Text(
                              user_id,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            child: Container(
                          padding: const EdgeInsets.only(
                              top: 30, right: 10, left: 10, bottom: 20),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(200, 131, 153, 168),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                            ),
                          ),
                          child: AnimationLimiter(
                            child: GridView.count(
                                childAspectRatio: 1.0,
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                crossAxisCount: 3,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                children: myList.map((data) {
                                  return AnimationConfiguration.staggeredGrid(
                                    position: myList.indexOf(data),
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    columnCount: 3,
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        data.onclickWidget));
                                          },
                                          child: Card(
                                            elevation: 4,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    38, 189, 187, 187),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    data.img,
                                                    width: 42,
                                                  ),
                                                  const SizedBox(
                                                    height: 14,
                                                  ),
                                                  Text(
                                                    data.title,
                                                    style: GoogleFonts.openSans(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        8,
                                                                        47,
                                                                        80),
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  // Text(
                                                  //   data.subtitle,
                                                  //   style: GoogleFonts.openSans(
                                                  //       textStyle:
                                                  //           const TextStyle(
                                                  //               color:
                                                  //                   Color
                                                  //                       .fromARGB(
                                                  //                           255,
                                                  //                           8,
                                                  //                           121,
                                                  //                           212),
                                                  //               fontSize: 10,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .w600)),
                                                  // ),
                                                  // const SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // Text(
                                                  //   data.event,
                                                  //   style: GoogleFonts.openSans(
                                                  //       textStyle:
                                                  //           const TextStyle(
                                                  //               color:
                                                  //                   Color
                                                  //                       .fromARGB(
                                                  //                           255,
                                                  //                           7,
                                                  //                           72,
                                                  //                           126),
                                                  //               fontSize: 10,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .w600)),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Widget onclickWidget;
  Items(
      {required this.title,
      required this.subtitle,
      required this.img,
      required this.event,
      required this.onclickWidget});
}
