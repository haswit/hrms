import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/services/messaging.dart';
import 'package:hrms_app/models/message.dart';
import 'package:hrms_app/views/notifications.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController titleController =
      TextEditingController(text: 'Title');
  final TextEditingController bodyController =
      TextEditingController(text: 'Body123');
  final List<Message> messages = [];

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('_firebaseMessagingBackgroundHandler');

    Future onDidReceiveLocalNotification(
        int? id, String? title, String? body, String? payload) async {
      print(title);
      print('onDidReceiveLocalNotification');
    }

    ///Not able to stop default notification
    ///there fore when custom notification is called
    ///result is 2 notifications displayed.

    // await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.notification?.title.toString()}");
      RemoteNotification? notification = message.notification;
      createNotification(message.notification?.title.toString(),
          message.notification?.body.toString());
      setState(() {
        messages.add(Message(
            title: message.notification!.title.toString(),
            body: notification!.body.toString()));
      });

      // showNotification(notification);
      print(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    // onLaunch: (Map<String, dynamic> message) async {
    //   print("onLaunch: $message");

    //   final notification = message['data'];
    //   setState(() {
    //     messages.add(Message(
    //       title: '${notification['title']}',
    //       body: '${notification['body']}',
    //     ));
    //   });
    // },
    // onResume: (Map<String, dynamic> message) async {
    //   print("onResume: $message");
    // },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
          RaisedButton(
            onPressed: sendNotification,
            child: Text('Send notification to all'),
          ),
        ]..addAll(messages.map(buildMessage).toList()),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content:
      //       Text('[${response.statusCode}] Error message: ${response.body}'),
      // ));
      print(response.statusCode);
    }
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}
