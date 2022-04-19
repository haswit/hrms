import 'package:flutter/material.dart';
import 'package:hrms_app/widgets/appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

var NotificationsData = [1, 2, 3, 4, 5];

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: headerNav("Notification"),
        body: Container(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: NotificationsData.length,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: Key(index.toString()), child: NotificationCard());
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        shadowColor: Color.fromARGB(141, 53, 44, 44),
        elevation: 14,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(children: [
            const Expanded(
                flex: 1,
                child: Icon(
                  Icons.notifications_none_sharp,
                  color: Colors.blue,
                )),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Notification Title",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(153, 0, 0, 0)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text("Notification Subtitle"),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.history,
                      size: 15,
                    ),
                    Text(
                      "08:20",
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
