import 'package:chomu/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';

import 'app/controllers/firebase_controller.dart';

void main() async {
  //Get Storage init
  await GetStorage.init();

  //firebase init

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase analytics

  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
  Get.put<FirebaseController>(
      FirebaseController(firebaseAnalytics: firebaseAnalytics));

  // put controllers
  putControllers();

  runApp(GetMaterialApp(
    title: "Chomu",
    theme: FlexThemeData.light(scheme: FlexScheme.deepPurple),
    darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepPurple),
    themeMode: ThemeMode.system,
    navigatorObservers: [firebaseAnalyticsObserver],
    home: const App(),
    getPages: [
      GetPage(name: "/", page: () => const App()),
    ],
  ));
}

putControllers() {}
