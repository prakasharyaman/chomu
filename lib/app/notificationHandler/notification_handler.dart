// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chomu/pages/settings/page/settingsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      print('hi testing');
      if (message.channelKey == "meme") {
        print('got a notification to open settings');
        if (message.id != null) {
          print('message id was not null and was ${message.id}');
          Get.to(SettingsPage());
        }
      }
    }
  }

  // handleNotification() {
  //   //Notification listner
  //   AwesomeNotifications()
  //       .actionStream
  //       .listen((ReceivedNotification receivedNotification) {
  //     _handleMessage(receivedNotification);
  //   });
  // }

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
