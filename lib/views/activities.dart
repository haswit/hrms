import 'package:flutter/material.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/timeline.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late List<Widget> timelineItems = [];
  late List<Widget> indicatorIcons = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Widget> temptimelineItems = [];
    List<Widget> tempindicatorIcons = [];

// Icon(Icons.access_alarm),
// Icon(Icons.accessibility_new),
// Icon(Icons.chat),
// Icon(Icons.photo),
// Icon(Icons.mic),

    //   HttpService().getAllSessions().then((value) {
    //     var sosData = value;

    //     print(sosData);

    //     for (var item in sosData) {
    //       if (item['session'] == "IN") {
    //         tempindicatorIcons.add(InIcon());
    //         temptimelineItems.add(InCard(item));
    //       } else {
    //         tempindicatorIcons.add(OutIcon());
    //         temptimelineItems.add(OutCard(item));
    //       }
    //     }
    //     setState(() {
    //       timelineItems = temptimelineItems;
    //       indicatorIcons = tempindicatorIcons;
    //     });
    //   });
  }

  SizedBox OutIcon() {
    return const SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ));
  }

  SizedBox inIcon() {
    return const SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.login_rounded,
          color: Colors.green,
        ));
  }

  Row inCard(Map<String, Object> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(item['date_time'].toString().split(" ")[0]),
        SizedBox(
          width: 250,
          height: 80,
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Lodded in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("12:40 PM")
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const SizedBox(
                      height: 15,
                      width: 30,
                      child: Center(
                        child: Text(
                          "IN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row OutCard(Map<String, Object> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(item['date_time'].toString().split(" ")[0]),
        SizedBox(
          width: 250,
          height: 80,
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Lodded out",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("12:40 PM")
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const SizedBox(
                      width: 30,
                      height: 15,
                      child: Center(
                        child: Text(
                          "OUT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: headerNav("Activities"),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Timeline(
            children: timelineItems,
            indicators: indicatorIcons,
          ),
        ),
      ),
    );
  }
}
