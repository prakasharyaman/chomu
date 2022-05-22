// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chomu/app/notificationHandler/widget/notificationWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      //TODO : handle notification
      if (message.channelKey == "meme" || message.channelKey == "debug") {
        if (message.id != null) {
          if (message.payload != null) {
            FirebaseController firebaseController = Get.find();
            firebaseController.logFirebaseEvent(
                eventName: 'Notification Click');
            Get.dialog(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: NotificationWidget(receivedNotification: message))));
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
