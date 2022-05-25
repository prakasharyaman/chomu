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
    this.tag,
  }) : super(key: key);
  final String? tag;
  @override
  Widget build(BuildContext context) {
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(
        screenClass: 'Story Player', screenName: 'Story Player');
    return Scaffold(
      body: GetBuilder<StoriesController>(
        init: StoriesController(tag: tag),
        builder: (controller) => Obx(() {
          switch (controller.status.value) {
            case Status.loading:
              return const Splash();
            case Status.loaded:
              return PageView.builder(
                itemCount: controller.memes.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.memes.length) {
                    return const StoriesFinished();
                  } else {
                    var post = controller.memes[index];
                    if (post.type == 'Animated') {
                      return VideoStoryPage(meme: controller.memes[index]);
                    } else if (post.type == 'Photo') {
                      return StoryPage(meme: post);
                    } else {
                      return StoryPage(
                        meme: post,
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
