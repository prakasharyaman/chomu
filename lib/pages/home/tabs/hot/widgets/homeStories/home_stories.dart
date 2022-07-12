// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'controller/home_stories_controller.dart';

class HomeStories extends GetView<HomeStoriesController> {
  const HomeStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 1.0, right: 2.0),
      child: GetBuilder<HomeStoriesController>(
        builder: (controller) {
          return Obx(() => controller.storiesWidget.value);
        },
        init: HomeStoriesController(),
      ),
    );
  }
}
