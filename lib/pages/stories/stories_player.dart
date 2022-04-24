import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/enum/status.dart';
import '../splash/splash.dart';

class StoryPlayer extends GetView<StoriesController> {
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StoriesController>(
        init: StoriesController(),
        builder: (controller) => Obx(() {
          switch (controller.status.value) {
            case Status.loading:
              return const Splash();
            case Status.loaded:
              return PageView.builder(
                itemCount: controller.memes.length,
                itemBuilder: (context, index) {
                  return StoryPage(meme: controller.memes[index]);
                },
                scrollDirection: Axis.vertical,
              );
            case Status.error:
              return Center(
                child: Text('Error'),
              );
          }
        }),
      ),
    );
  }
}
