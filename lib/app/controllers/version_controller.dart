import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionController extends GetxController {
  static VersionController versionController = Get.find();
  PackageInfo? packageInfo;
  @override
  void onInit() {
    super.onInit();
    createPackageInfo();
  }

  @override
  void onReady() {
    super.onReady();
    // Instantiate NewVersion manager
    checkforUpdate();
    // reviewRequest();
  }

// create package info
  createPackageInfo() async {
    debugPrint('createPackageInfo');
    packageInfo = await PackageInfo.fromPlatform();
  }

// check for latest app updates
  checkforUpdate() {
    try {
      debugPrint('checking for update');
      final newVersion = NewVersion(
        androidId: 'com.otft.chomu',
      );
      //  let the plugin handle fetching the status and showing a dialog,
      // or we can fetch the status and display our own dialog, or no dialog.
      const simpleBehavior = true;

      if (simpleBehavior) {
        basicStatusCheck(newVersion);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // else {
    //   // if we need to show alert custom
    //   // advancedStatusCheck(newVersion);
    // }
  }

//review request
  // reviewRequest() async {
  //   final InAppReview inAppReview = InAppReview.instance;
  //   Future.delayed(const Duration(seconds: 2), () async {
  //     if (await inAppReview.isAvailable()) {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         inAppReview.requestReview();
  //       });
  //     }
  //   });
  // }
}

// basic status check
basicStatusCheck(NewVersion newVersion) {
  if (Get.context != null) {
    newVersion.showAlertIfNecessary(context: Get.context!);
  } else {
    debugPrint('Context is null');
  }
}

// advanced status check for custom dialog
advancedStatusCheck(NewVersion newVersion) async {
  final status = await newVersion.getVersionStatus();
  if (status != null) {
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      context: Get.context!,
      versionStatus: status,
      dialogTitle: 'Custom Title',
      dialogText: 'Custom Text',
    );
  }
}
