import 'dart:math';
import 'package:chomu/pages/home/games/games_page.dart';
import 'package:chomu/pages/profile/bindings/profile_bindings.dart';
import 'package:chomu/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // Get.to(const StoryPlayer());
      currentPage = index;
      update();
    } else if (index == 2) {
      Get.to(const GamesPage());
    } else if (index == 3) {
      Get.to(const Profile(), binding: ProfileBindings());
    } else {
      currentPage = index;
      showBadge.value = false;
      update();
    }
  }
}
