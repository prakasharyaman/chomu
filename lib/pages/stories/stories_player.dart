import 'package:chomu/pages/home/controller/home_controller.dart';
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
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(
        screenClass: 'Stories', screenName: 'Stories');
    return WillPopScope(
      onWillPop: () {
        HomeController homeController = Get.find();
        homeController.changeCurrentPage(0);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GetBuilder<StoriesController>(
            init: StoriesController(),
            builder: (controller) => Obx(() {
              switch (controller.status.value) {
                case Status.loading:
                  return const Splash();
                case Status.loaded:
                  var memes = controller.memes;
                  // scroller
                  return Column(
                    children: [
                      //ad widget
                      Container(
                        color: Colors.black,
                        height: 50,
                        width: double.infinity,
                        child: Obx(() => controller.adWidget.value),
                      ),
                      // page view
                      Expanded(
                        child: PageView.builder(
                          itemCount: memes.length + 1,
                          itemBuilder: (context, index) {
                            if (index == memes.length) {
                              return const StoriesFinished();
                            } else {
                              var post = memes[index];
                              if (post.type == 'Animated') {
                                return VideoStoryPage(
                                  currentPage: index,
                                  meme: memes[index],
                                  tag: null,
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
                        ),
                      ),
                    ],
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
        ),
      ),
    );
  }
}

            //  TikTokStyleFullPageScroller(
            //         swipePositionThreshold: 0.2,
            //         contentSize: memes.length + 1,
            //         builder: (BuildContext context, int index) {
            //           if (index == memes.length) {
            //             return const StoriesFinished();
            //           } else {
            //             var post = memes[index];
            //             if (post.type == 'Animated') {
            //               return Scaffold(
            //                 body: VideoStoryPage(
            //                   currentPage: index,
            //                   meme: memes[index],
            //                   tag: null,
            //                   pageController: controller.pageController,
            //                 ),
            //               );
            //             } else if (post.type == 'Photo') {
            //               return StoryPage(
            //                 meme: post,
            //                 pageController: controller.pageController,
            //               );
            //             } else {
            //               return StoryPage(
            //                 meme: post,
            //                 pageController: controller.pageController,
            //               );
            //             }
            //           }
            //         });
             