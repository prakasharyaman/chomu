// ignore_for_file: avoid_print

// 🐦 Flutter imports:
import 'package:chomu/pages/home/controller/home_page_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/repository/data_repository.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:chomu/pages/home/games/controller/games_page_controller.dart';
import 'package:chomu/pages/introduction/introduction_screen.dart';
import '../../models/user_model.dart';

class FirebaseController extends GetxController {
  //analytics variables
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  //login variables
  static FirebaseController firebaseController = Get.find();
  final storage = GetStorage();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rxn<User> user = Rxn<User>();
  DateTime dateTime = DateTime.now();
  var userModel = UserModel().obs;
  Stream<User?> get userStream => firebaseAuth.authStateChanges();
  @override
  void onInit() {
    //log app open
    firebaseAnalytics.logAppOpen();
    //run every time auth state changes
    ever(user, handleAuthChanged);
    //bind to user model
    user.bindStream(userStream);
    // subscribe to topic

    FirebaseMessaging.instance.subscribeToTopic('meme');

    super.onInit();
  }

  getUid() {
    return user.value?.uid;
  }

  handleAuthChanged(firebaseUser) async {
    //get user data from firestore
    if (firebaseUser?.uid != null) {
      Get.put<StoriesController>(StoriesController());
      Get.put<HomePageController>(HomePageController());
      Get.put<GamesPageController>(GamesPageController());
      userModel.value = UserModel(id: firebaseUser.uid);
      FirebaseCrashlytics.instance.setUserIdentifier(firebaseUser.uid);
      await firebaseAnalytics.logLogin();
      await firebaseAnalytics.setUserId(id: firebaseUser.uid);
      //log user on cloud
      logUserActiveTodayOnCloud();
      // check for introduction
      checkForIntroduction();
      //check for update
      checkForLatestVersion();
      print(userModel.value.id);
    } else if (firebaseUser == null) {
      await signIn();
    }
  }

  signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  signIn() async {
    try {
      await firebaseAuth.signInAnonymously();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.purpleAccent,
      );
    }
  }

  logCurrentScreen(
      {required String screenClass, required String screenName}) async {
    try {
      await firebaseAnalytics.setCurrentScreen(screenName: screenName);
      await firebaseAnalytics.logScreenView(
          screenClass: screenClass, screenName: screenName);
    } catch (e) {
      print(e);
    }
  }

  logFirebaseEvent({required String eventName}) async {
    try {
      await firebaseAnalytics.logEvent(name: eventName);
    } catch (e) {
      print(e);
    }
  }

//log user as active today
  logUserActiveTodayOnCloud() async {
    try {
      var date = DataRepository().getDate();
      await FirebaseFirestore.instance
          .collection('users')
          .doc('active_users')
          .collection(date)
          .doc(await getUid())
          .set({'userId': await getUid(), 'date': date});
      await saveUserTokenAndDeviceType();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //save user token
  saveUserTokenAndDeviceType() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      debugPrint('Running on ${androidInfo.model}');
      var token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('users').doc(getUid()).set({
        'token': token,
        'deviceType': androidInfo.model,
        'id': getUid(),
        'lastActive': DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  checkForIntroduction() async {
    try {
      var introductionShown = storage.read('introductionShown');
      if (introductionShown == null || introductionShown == false) {
        debugPrint('showing introduction');
        await storage.write('introductionShown', true);
        Get.to(const Introduction());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// check for latest build number
  checkForLatestVersion() async {
    try {
      debugPrint('Checking for latest version');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // ignore: unnecessary_null_comparison
      if (packageInfo.buildNumber != null) {
        var buildNumber = int.parse(packageInfo.buildNumber);
        var cloudBuildDoc = await FirebaseFirestore.instance
            .collection('app')
            .doc('latestBuildNumber')
            .get();
        if (cloudBuildDoc.exists) {
          var cloudBuildData = cloudBuildDoc.data();
          if (cloudBuildData != null) {
            var cloudBuildNumber = cloudBuildData['latestBuildNumber'];

            if (cloudBuildNumber != null) {
              if (cloudBuildNumber > buildNumber) {
                Get.defaultDialog(
                  title: 'New Update Available !',
                  buttonColor: Colors.deepPurple,
                  cancelTextColor:
                      Get.isDarkMode ? Colors.white : Colors.deepPurple,
                  confirmTextColor: Colors.white,
                  middleText:
                      'Please update to the latest version to get the best experience',
                  textConfirm: 'Update',
                  textCancel: 'Later',
                  onConfirm: () async {
                    var url = Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.otft.chomu');

                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      debugPrint('Could not launch $url');
                    }
                  },
                );
              } else if (cloudBuildNumber == buildNumber) {
                debugPrint('The app is at latest version : $buildNumber');
              } else {
                debugPrint('The app is AWOL  : $buildNumber');
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveUserAge({required int age}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(getUid()).set({
        'age': age,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // logInAnalytics() async {
  //   try {
  //     await firebaseAnalytics.
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
