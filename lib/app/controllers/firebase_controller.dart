// ignore_for_file: avoid_print

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';

class FirebaseController extends GetxController {
  //analytics variables
  final FirebaseAnalytics firebaseAnalytics;
  FirebaseController({required this.firebaseAnalytics});
  //login variables
  static FirebaseController firebaseController = Get.find();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Rxn<User> user = Rxn<User>();
  var userModel = UserModel().obs;

  Stream<User?> get userStream => firebaseAuth.authStateChanges();

  @override
  void onReady() {
    //log app open
    firebaseAnalytics.logAppOpen();
    //run every time auth state changes
    ever(user, handleAuthChanged);

    user.bindStream(userStream);

    super.onReady();
  }

  getUid() {
    return user.value?.uid;
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      userModel.value = UserModel(id: _firebaseUser.uid);
      firebaseAnalytics.setUserId(id: _firebaseUser.uid);
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
        backgroundColor: Colors.redAccent,
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
        backgroundColor: Colors.redAccent,
      );
    }
  }

  logCurrentScreen({required String screenName}) async {
    try {
      await firebaseAnalytics.setCurrentScreen(screenName: screenName);
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
}
