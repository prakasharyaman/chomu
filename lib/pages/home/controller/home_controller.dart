import 'dart:math';

import 'package:chomu/pages/profile/bindings/profile_bindings.dart';
import 'package:chomu/pages/profile/profile.dart';
import 'package:chomu/pages/stories/stories_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController homeController = Get.find();
  GlobalKey<ScaffoldState> drawerOpenKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  var currentPage = 0;
  var showBadge = true.obs;
  int generateRandomBadgeNumber() {
    return Random().nextInt(25) + 1;
  }

  void changeCurrentPage(int index) {
    if (index == 1) {
      showBadge.value = false;
      Get.to(const StoryPlayer());
    } else if (index == 2) {
      Get.to(const Profile(), binding: ProfileBindings());
    } else {
      currentPage = index;
      update();
    }
  }
}
