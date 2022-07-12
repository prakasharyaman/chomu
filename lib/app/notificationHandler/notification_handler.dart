// ignore_for_file: avoid_print

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/app/notificationHandler/widget/notificationWidget.dart';
import '../controllers/firebase_controller.dart';

class NotificationMessageHandler extends StatefulWidget {
  final Widget child;
  const NotificationMessageHandler({Key? key, required this.child})
      : super(key: key);

  @override
  _NotificationMessageHandlerState createState() =>
      _NotificationMessageHandlerState();
}

class _NotificationMessageHandlerState
    extends State<NotificationMessageHandler> {
  void _handleMessage(ReceivedNotification message) {
    if (message.body != null) {
      if (message.channelKey == "meme") {
        if (message.id != null) {
          if (message.payload != null) {
            FirebaseController firebaseController = Get.find();
            firebaseController.logFirebaseEvent(eventName: 'notificationclick');
            Get.dialog(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: NotificationWidget(receivedNotification: message))));
          }
        }
      } else if (message.channelKey == "general") {
        if (message.id != null) {
          if (message.title != null && message.body != null) {
            Get.defaultDialog(title: message.title!, middleText: message.body!);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('meme');
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      _handleMessage(receivedNotification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
