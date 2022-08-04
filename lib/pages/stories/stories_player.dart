// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:get/get.dart';
// 🌎 Project imports:
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/widget/story_finished.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:chomu/pages/stories/widget/video_story_page.dart';
import '../../common/enum/status.dart';
import '../error/error.dart';
import '../splash/splash.dart';

class StoryPlayer extends StatelessWidget {
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        HomeController homeController = Get.find();
        homeController.changeCurrentPage(0);
        StoriesController storiesController = Get.find();
        storiesController
            .pauseControllerAtIndex(storiesController.focusedindex);
        return Future.value(false);
      },
      child: GetBuilder<StoriesController>(
        init: StoriesController(),
        builder: (controller) => Obx(() {
          switch (controller.storiesStatus.value) {
            case Status.loading:
              return const Splash();
            case Status.loaded:
              // scroller stories
              return const StoryPlayerBuilder();
            case Status.error:
              return ErrorScreen(
                error: 'There was a problem while showing the stories',
                onTap: () {
                  HomeController homeController = Get.find();
                  homeController.changeCurrentPage(0);
                },
              );
          }
        }),
      ),
    );
  }
}

class StoryPlayerBuilder extends GetView<StoriesController> {
  const StoryPlayerBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ninePosts = controller.ninePosts;
    return PageView.builder(
      itemCount: ninePosts.length + 1,
      itemBuilder: (context, index) {
        if (index >= ninePosts.length) {
          return const StoriesFinished();
        } else {
          var ninePost = ninePosts[index];
          if (ninePost.type == 'Animated') {
            return VideoStoryPage(
              ninePost: ninePosts[index],
              index: index,
              videoPlayerController: controller.controllers[index],
            );
          } else {
            return StoryPage(
              ninePost: ninePosts[index],
              pageController: controller.pageController,
            );
          }
        }
      },
      scrollDirection: Axis.vertical,
      controller: controller.pageController,
      onPageChanged: (index) => controller.onvideoIndexChanged(index: index),
    );
  }
}
