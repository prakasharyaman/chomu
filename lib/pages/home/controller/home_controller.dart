import 'package:chomu/pages/stories/stories_player.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController homeController = Get.find();
  var currentPage = 0;

  void changeCurrentPage(int index) {
    if (index == 1) {
      Get.to(const StoryPlayer());
    } else {
      currentPage = index;
      update();
    }
  }
}
