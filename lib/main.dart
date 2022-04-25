import 'package:chomu/app/controllers/theme_controller.dart';
import 'package:chomu/firebase_options.dart';
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';

import 'app/controllers/firebase_controller.dart';
import 'pages/home/tabs/hot/controller/hot_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Get Storage init
  await GetStorage.init();

  //firebase init

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //TODO : uncomment crashlytics

// // Pass all uncaught errors from the framework to Crashlytics.
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //firebase analytics

  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  // put controllers
  Get.put<FirebaseController>(
      FirebaseController(firebaseAnalytics: firebaseAnalytics));
  Get.put<HomeController>(HomeController());
  Get.put<HotController>(HotController());
  Get.put<ThemeController>(ThemeController());
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
