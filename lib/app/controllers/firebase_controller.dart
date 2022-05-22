// ignore_for_file: avoid_print

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/user_model.dart';

class FirebaseController extends GetxController {
  //analytics variables
  final FirebaseAnalytics firebaseAnalytics;
  FirebaseController({required this.firebaseAnalytics});
  //login variables
  static FirebaseController firebaseController = Get.find();
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
    // initiate ads
    _initGoogleMobileAds();
    super.onInit();
  }

  getUid() {
    return user.value?.uid;
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      userModel.value = UserModel(id: _firebaseUser.uid);
      await firebaseAnalytics.logLogin();
      await firebaseAnalytics.setUserId(id: _firebaseUser.uid);
      FirebaseCrashlytics.instance.setUserIdentifier(_firebaseUser.uid);
      print(userModel.value.id);
    } else if (_firebaseUser == null) {
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

  _initGoogleMobileAds() async {
    await MobileAds.instance.initialize();
  }
  // logInAnalytics() async {
  //   try {
  //     await firebaseAnalytics.
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
