import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';

class VersionController extends GetxController {
  static VersionController versionController = Get.find();

  @override
  void onReady() {
    super.onReady();
    // Instantiate NewVersion manager
    checkforUpdate();
  }

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
