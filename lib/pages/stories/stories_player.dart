import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/widget/story_finished.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:chomu/pages/stories/widget/video_story_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app.dart';
import '../../app/controllers/firebase_controller.dart';
import '../../common/enum/status.dart';
import '../error/error.dart';
import '../splash/splash.dart';

class StoryPlayer extends GetView<StoriesController> {
  const StoryPlayer({
    Key? key,
    this.postTag,
  }) : super(key: key);
  final String? postTag;
  @override
  Widget build(BuildContext context) {
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(
        screenClass: 'Story Player', screenName: 'Story Player');
    return Scaffold(
      body: GetBuilder<StoriesController>(
        init: StoriesController(tag: postTag),
        builder: (controller) => Obx(() {
          switch (controller.status.value) {
            case Status.loading:
              if (postTag != null) {
                controller.getStoryByTag(tag: postTag!);
              }
              return const Splash();
            case Status.loaded:
              var memes = controller.memes;
              return PageView.builder(
                itemCount: memes.length + 1,
                itemBuilder: (context, index) {
                  if (index == memes.length) {
                    return const StoriesFinished();
                  } else {
                    var post = memes[index];
                    if (post.type == 'Animated') {
                      return VideoStoryPage(
                        meme: memes[index],
                        pageController: controller.pageController,
                      );
                    } else if (post.type == 'Photo') {
                      return StoryPage(
                        meme: post,
                        pageController: controller.pageController,
                      );
                    } else {
                      return StoryPage(
                        meme: post,
                        pageController: controller.pageController,
                      );
                    }
                  }
                },
                scrollDirection: Axis.vertical,
                controller: controller.pageController,
              );
            case Status.error:
              return ErrorScreen(
                error: 'There was a problem while showing the stories',
                onTap: () {
                  Get.offAll(const App());
                },
              );
          }
        }),
      ),
    );
  }
}
