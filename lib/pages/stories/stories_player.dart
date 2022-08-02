// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/widget/story_finished.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:chomu/pages/stories/widget/video_story_page.dart';
import '../../ads/ads_helper.dart';
import '../../app/app.dart';
import '../../app/controllers/firebase_controller.dart';
import '../../common/enum/status.dart';
import '../error/error.dart';
import '../splash/splash.dart';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({Key? key}) : super(key: key);

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        HomeController homeController = Get.find();
        homeController.changeCurrentPage(0);
        return Future.value(false);
      },
      child: const StoryPlayer(),
    );
  }
}

class StoryPlayer extends GetView<StoriesController> {
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoriesController>(
      init: StoriesController(),
      builder: (controller) => Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            var memes = controller.memes;
            // scroller stories
            return PageView.builder(
              itemCount: memes.length,
              itemBuilder: (context, index) {
                final bool _isLoading = (index == controller.urls.length - 1);
                if (index == memes.length) {
                  return const StoriesFinished();
                } else {
                  var post = memes[index];
                  if (post.type == 'Animated') {
                    return VideoStoryPage(
                      meme: memes[index],
                      videoPlayerController: controller.controllers[index],
                      isLoading: _isLoading,
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
              onPageChanged: (index) =>
                  controller.onvideoIndexChanged(index: index),
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
    );
  }
}
