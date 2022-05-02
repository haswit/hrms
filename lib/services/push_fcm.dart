// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class FCM {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final streamCtlr = StreamController<String>.broadcast();

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print(
        '---------------------------------------background---------------------------');

    Future onDidReceiveLocalNotification(
        int? id, String? title, String? body, String? payload) async {
      print(title);
      print(
          '---------------------------------------------notification----------------------');
    }

    ///Not able to stop default notification
    ///there fore when custom notification is called
    ///result is 2 notifications displayed.

    // await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  setNotifications() {
    _firebaseMessaging.subscribeToTopic("all");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // showNotification(notification);
      print("------------------------------line 49---------------");
      print(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    final token = _firebaseMessaging.getToken().then((value) => print(value));
    print(token);
  }

  dispose() {
    streamCtlr.close();
  }
}
