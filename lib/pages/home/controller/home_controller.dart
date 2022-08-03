// 🎯 Dart imports:
import 'dart:math';

// 🐦 Flutter imports:
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports

class HomeController extends GetxController {
  static HomeController homeController = Get.find();
  GlobalKey<ScaffoldState> drawerOpenKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  var currentPage = 1;
  var showBadge = true.obs;
  int generateRandomBadgeNumber() {
    return Random().nextInt(25) + 1;
  }

  void changeCurrentPage(int index) {
    if (index == 1) {
      showBadge.value = false;
      StoriesController storiesController = Get.find();
      storiesController.getNinePosts();
      currentPage = index;
      update();
    } else if (index == 2) {
      currentPage = index;
      update();
    } else if (index == 3) {
    } else {
      currentPage = index;
      showBadge.value = false;
      update();
    }
  }
}
