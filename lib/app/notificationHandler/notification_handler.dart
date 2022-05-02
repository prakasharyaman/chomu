// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
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
      if (message.channelKey == "meme") {
        if (message.id != null) {
          if (message.payload != null) {
            FirebaseController firebaseController = Get.find();
            firebaseController.logFirebaseEvent(
                eventName: 'Notification Click');
            Get.dialog(Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            message.title!,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image(
                          image: message.bigPictureImage!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 300,
                          errorBuilder: (BuildContext context, Object object,
                              StackTrace? stackTrace) {
                            return const SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Center(child: Icon(Icons.error)));
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar('Thanks For FeedBack',
                                        'We will show more posts like this',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 2));
                                  },
                                  icon: const Icon(Icons.thumb_up)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                  onPressed: () {
                                    Get.snackbar('Thanks For FeedBack',
                                        'We will show less posts like this',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 2));
                                    Future.delayed(
                                        const Duration(milliseconds: 2100), () {
                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: const Icon(Icons.thumb_down)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
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
