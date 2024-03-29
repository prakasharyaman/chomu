// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rating_dialog/rating_dialog.dart';

class VersionController extends GetxController {
  static VersionController versionController = Get.find();
  PackageInfo? packageInfo;
  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    createPackageInfo();
  }

  @override
  void onReady() {
    super.onReady();
    appOpenLog();
  }

// create package info
  createPackageInfo() async {
    debugPrint('createPackageInfo');
    packageInfo = await PackageInfo.fromPlatform();
  }

// log number of times app open
  appOpenLog() async {
    var appOpenCount = await storage.read('appOpenCount');
    if (appOpenCount == null) {
      debugPrint('app opened for the first time');
      await storage.write('appOpenCount', 1);
    } else if (appOpenCount >= 5) {
      if (await isReviewRequested() == false) {
        logReviewRequested(isReviewRequested: true);
        // request for review
        reviewRequest();
      }
    } else {
      debugPrint('No. of times app opened is: $appOpenCount ');
      await storage.write('appOpenCount', appOpenCount + 1);
    }
  }

// reset appOpenCount
  resetAppOpenCount() async {
    await storage.write('appOpenCount', 0);
  }

// check if review requested
  Future<bool> isReviewRequested() async {
    var reviewRequested = await storage.read('reviewRequested');
    if (reviewRequested == null) {
      await storage.write('reviewRequested', false);
      return false;
    } else {
      return reviewRequested;
    }
  }

  // log review requested
  logReviewRequested({required bool isReviewRequested}) async {
    var reviewRequested = await storage.read('reviewRequested');
    if (reviewRequested == null) {
      await storage.write('reviewRequested', isReviewRequested);
    } else {
      await storage.write('reviewRequested', isReviewRequested);
    }
  }

// review request
  reviewRequest() async {
    final dialog = RatingDialog(
      initialRating: 5.0,
      //  app's name
      title: const Text(
        'Like CHOMU ?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage  user to leave a high rating
      message: const Text(
        'Tap submit to set your rating',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      //  app's logo
      image: Image.asset('assets/images/logo.png'),
      submitButtonText: 'Submit',
      commentHint: 'Tell us what you think',
      onCancelled: () {
        // review was cancelled, ask for it later
        logReviewRequested(isReviewRequested: false);
        // reset number of times app has ben opened
        resetAppOpenCount();
        debugPrint('cancelled,will ask 5 days later');
      },
      onSubmitted: (response) {
        debugPrint('rating: ${response.rating}, comment: ${response.comment}');

        if (response.rating >= 4.0) {
          debugPrint('asking for google play review');
          logReviewRequested(isReviewRequested: true);
          final InAppReview inAppReview = InAppReview.instance;
          Future.delayed(const Duration(milliseconds: 50), () async {
            if (await inAppReview.isAvailable()) {
              await inAppReview.requestReview();
            }
          });
        } else {
          // review was not good ask for it later
          logReviewRequested(isReviewRequested: false);
          // reset number of times app has ben opened
          resetAppOpenCount();
          // send a promise snackbar
          Get.snackbar(
              'We Promise To Improve !', 'Please share your feedback with us',
              snackPosition: SnackPosition.BOTTOM,
              icon: const Icon(Icons.logo_dev_rounded));
        }
      },
    );
    // show the dialog
    Get.dialog(dialog);
  }
}
