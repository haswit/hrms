import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms_app/constants.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/services/my_shared_prederences.dart';
import 'package:hrms_app/views/activities.dart';
import 'package:hrms_app/views/attendance.dart';
import 'package:hrms_app/views/notification_screen.dart';
import 'package:hrms_app/views/settings_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hrms_app/views/incedent_responce.dart';
import 'package:hrms_app/views/utils.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user_id = "";
  int pageIndex = 0;
  final _pageController = PageController(initialPage: 0, keepPage: true);

  final pages = [
    LandingScreen(),
    const SubmitIncedent(),
    const NotificationScreen(),
    const Settings(),
  ];

  final titles = [
    "AppStrings.homeTitle".tr(),
    "AppStrings.incidentTitle".tr(),
    "AppStrings.notificationTitle".tr(),
    "AppStrings.settingsTitle".tr()
  ];

  @override
  void initState() {
    super.initState();

    MySharedPreferences.instance.getStringValue("id").then((value) {
      setState(() {
        user_id = value;
      });
    });

    _pageController.addListener(() {
      setState(() {
        pageIndex = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("-------------${context.locale}");
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Attendance()));
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: ConstantStrings.kPrimaryColor),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: bottomNav(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          titles[pageIndex],
          style: TextStyle(
              color: ConstantStrings.kPrimaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              HttpService.logout(context);
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.logout,
                  color: ConstantStrings.kPrimaryColor,
                )),
          )
        ],
      ),
      body: user_id == null
          ? Container(
              height: double.infinity,
              color: ConstantStrings.kPrimaryColorLite,
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
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ConstantStrings.kPrimaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
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
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        color: ConstantStrings.lightGrey,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: PageView.builder(
                            itemCount: pages.length,
                            scrollDirection: Axis.horizontal,
                            controller: _pageController,
                            itemBuilder: (context, itemIndex) {
                              return pages[itemIndex];
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container bottomNav(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageController.jumpToPage(0);
              });
            },
            icon: pageIndex == 0
                ? Icon(
                    Icons.home_filled,
                    color: ConstantStrings.kPrimaryColor,
                    size: 25,
                  )
                : Icon(
                    Icons.home_outlined,
                    color: ConstantStrings.kPrimaryColorLite,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageController.jumpToPage(1);
              });
            },
            icon: pageIndex == 1
                ? Icon(
                    Icons.camera_alt_rounded,
                    color: ConstantStrings.kPrimaryColor,
                    size: 25,
                  )
                : Icon(
                    Icons.camera_alt_outlined,
                    color: ConstantStrings.kPrimaryColorLite,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageController.jumpToPage(2);
              });
            },
            icon: pageIndex == 2
                ? Icon(
                    Icons.notifications,
                    color: ConstantStrings.kPrimaryColor,
                    size: 25,
                  )
                : Icon(
                    Icons.notifications_outlined,
                    color: ConstantStrings.kPrimaryColorLite,
                    size: 25,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                _pageController.jumpToPage(3);
              });
            },
            icon: pageIndex == 3
                ? Icon(
                    Icons.settings,
                    color: ConstantStrings.kPrimaryColor,
                    size: 25,
                  )
                : Icon(
                    Icons.settings_outlined,
                    color: ConstantStrings.kPrimaryColorLite,
                    size: 25,
                  ),
          ),
        ],
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String siteName = "";
  String siteNameAr = "";
  List<dynamic> items = [];
  late SharedPreferences pref;
  bool isLoaded = false;

  initSharedPrefs() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      siteName = pref.getString("siteName").toString();
      siteNameAr = pref.getString("siteNameAr").toString();
    });
  }

  fetchData() async {
    var recentActivity = await HttpService().getcheckInEmployee();
    print("--------data---list------------");
    print(recentActivity);
    setState(() {
      items = recentActivity['items'];
      isLoaded = true;
    });
  }

  getFormatDate(String d) {
    var date = DateTime.parse(d);
    return DateFormat("y-M-d").format(date);
  }

  getFormatTime(String d, String t) {
    d = d.toString().split("T")[0];

    print(d);
    var date = DateTime.parse("$d $t");
    return DateFormat("H:m").format(date);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPrefs();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print("---------locale---${context.locale}");
    return SizedBox(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SiteCard(context),
              Sized30(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.5, color: Colors.purpleAccent)),
                    ),
                    child: Text(
                      "AppStrings.recentActivities".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: ConstantStrings.kPrimaryColorLite),
                    ),
                  ),
                  Container(
                    child: isLoaded == false
                        ? Container(
                            height: 200,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: CircularProgressIndicator(),
                            )),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    items.length,
                                    (index) => SizedBox(
                                          height: 70,
                                          child: Card(
                                            elevation: 4,
                                            child: Row(children: [
                                              Container(
                                                color: ConstantStrings
                                                    .kPrimaryColorLite,
                                                width: 5,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "SiteCode: ${items[index]['siteCode']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "${getFormatDate(items[index]['date'])}"),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "${getFormatTime(items[index]['date'], items[index]['inTime'])} to"),
                                                              Text(
                                                                  " ${getFormatTime(items[index]['date'], items[index]['outTime'])}"),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        )),
                              ),
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox Sized30() {
    return const SizedBox(
      height: 30,
    );
  }

  SizedBox SiteCard(BuildContext context) {
    return SizedBox(
        height: 150,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
              color: ConstantStrings.kPrimaryColor,
              boxShadow: [
                BoxShadow(
                  color: ConstantStrings.kPrimaryColorLite,
                  blurRadius: 5.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "AppStrings.mysite".tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w200),
                  ),
                  const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                  context.locale.toString() == "en_US" ? siteName : siteNameAr,
                  style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(255, 255, 255, 255))),
            ),
          ]),
        ));
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
