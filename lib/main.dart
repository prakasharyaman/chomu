// 🎯 Dart imports:
import 'dart:async';
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wakelock/wakelock.dart';

// 🌎 Project imports:
import 'package:chomu/ads/controller/ads_controller.dart';
import 'package:chomu/app/controllers/theme_controller.dart';
import 'package:chomu/app/controllers/version_controller.dart';
import 'package:chomu/app/controllers/volume_controller.dart';
import 'package:chomu/firebase_options.dart';
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/services/download_service.dart';
import 'app/app.dart';
import 'app/controllers/firebase_controller.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    // zoned method of running
    WidgetsFlutterBinding.ensureInitialized();

    //Get Storage init
    await GetStorage.init();

    //firebase init

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // awesome notifications
    AwesomeNotifications().initialize(
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
            channelGroupKey: 'meme',
            channelKey: 'meme',
            channelName: 'Memes',
            channelDescription: 'Just a random reminder to be happy',
            importance: NotificationImportance.High),
        NotificationChannel(
            channelGroupKey: 'updates',
            channelKey: 'updates',
            channelName: 'Updates',
            channelDescription: 'Crucial App Update Notifications',
            importance: NotificationImportance.High),
        NotificationChannel(
            channelGroupKey: 'general',
            channelKey: 'general',
            channelName: 'General',
            channelDescription: 'General Notifications',
            importance: NotificationImportance.High),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'meme', channelGroupName: 'Memes'),
        NotificationChannelGroup(
            channelGroupkey: 'updates', channelGroupName: 'Updates'),
        NotificationChannelGroup(
            channelGroupkey: 'general', channelGroupName: 'General'),
      ],
    );

// Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    //firebase analytics

    FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver firebaseAnalyticsObserver =
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
    // firebase messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // put controllers
    // firebase controller to handle login ,analytics ,etc
    Get.put<FirebaseController>(
        FirebaseController(firebaseAnalytics: firebaseAnalytics));
    // home controller
    Get.put<HomeController>(HomeController());
    // theme control
    Get.put<ThemeController>(ThemeController());
    // video volumen control
    Get.put<VolumeController>(VolumeController());
    // check for latest version
    Get.put<VersionController>(VersionController());
    // download services
    Get.put<FileDownloadService>(FileDownloadService());
    // ads services
    Get.put<AdsController>(AdsController());
    Wakelock.enable();
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chomu",
      theme: FlexThemeData.light(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      navigatorObservers: [firebaseAnalyticsObserver],
      home: const App(),
    ));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

// messaging firebase handling
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  try {
    if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
            considerWhiteSpaceAsEmpty: true) ||
        !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
            considerWhiteSpaceAsEmpty: true)) {
      debugPrint(
          'message also contained a notification: ${message.notification}');

      String? imageUrl;
      imageUrl ??= message.notification!.android?.imageUrl;
      imageUrl ??= message.notification!.apple?.imageUrl;

      Map<String, dynamic> notificationAdapter = {
        NOTIFICATION_CHANNEL_KEY: 'basic_channel',
        NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
            message.messageId ??
            Random().nextInt(2147483647),
        NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
                ?[NOTIFICATION_TITLE] ??
            message.notification?.title,
        NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
                ?[NOTIFICATION_BODY] ??
            message.notification?.body,
        NOTIFICATION_LAYOUT: AwesomeStringUtils.isNullOrEmpty(imageUrl)
            ? 'Default'
            : 'BigPicture',
        NOTIFICATION_BIG_PICTURE: imageUrl
      };

      AwesomeNotifications()
          .createNotificationFromJsonData(notificationAdapter);
    } else {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
