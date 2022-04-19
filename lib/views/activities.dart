import 'dart:developer';

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
    var sos_data = [
      {"id": 1, "session": "OUT", "date_time": "20-11-2022", "site": "Site A"},
      {"id": 1, "session": "IN", "date_time": "20-11-2022", "site": "Site A"},
    ];

    for (var item in sos_data) {
      if (item['session'] == "IN") {
        tempindicatorIcons.add(InIcon());
        temptimelineItems.add(InCard(item));
      } else {
        tempindicatorIcons.add(OutIcon());
        temptimelineItems.add(OutCard(item));
      }
    }

    setState(() {
      timelineItems = temptimelineItems;
      indicatorIcons = tempindicatorIcons;
    });
  }

  SizedBox OutIcon() {
    return SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ));
  }

  SizedBox InIcon() {
    return SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.login_rounded,
          color: Colors.green,
        ));
  }

  Row InCard(Map<String, Object> item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(item['date_time'].toString()),
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
                    children: [
                      Text(
                        "Lodded in at ${item['site']}",
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
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
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
        Text(item['date_time'].toString()),
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
                    children: [
                      Text(
                        "Lodded out from ${item['site']}",
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
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
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
          padding: EdgeInsets.all(15),
          child: Timeline(
            children: timelineItems,
            indicators: indicatorIcons,
          ),
        ),
      ),
    );
  }
}
