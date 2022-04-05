import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

Future<void> createNotification(title, body) async {
  Random random = Random();
  int randomNumber = random.nextInt(100000);

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: randomNumber, channelKey: 'key1', title: title, body: body));
}
