import 'package:chomu/models/meme_model.dart';
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/stories_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../../../repository/stories_repository.dart';

class HomeStoriesController extends GetxController {
  static HomeStoriesController homeStoriesController = Get.find();
  StoriesRepository storiesRepository = StoriesRepository();
  HotController hotController = Get.find();
  // ignore: avoid_unnecessary_containers
  var storiesWidget = Container(child: const LinearProgressIndicator()).obs;
  @override
  void onInit() {
    _buildStoriesWidget();
    super.onInit();
  }

  _buildStoriesWidget() async {
    try {
      var tagsList = [];
      List<Meme> stories = [];
      var tempstories = await storiesRepository.getNewsPosts();

      if (tempstories != null) {
        stories = tempstories;
        for (Meme story in stories) {
          var tags = story.tags;
          if (tags != null) {
            for (var tag in tags) {
              if (tag['key'] != null) {
                tagsList.add(tag['key']);
              }
            }
          }
        }
      }
      Map<String, int> tagsCount = {};
      for (var tag in tagsList) {
        tagsCount[tag] = (tagsCount[tag] ?? 0) + 1;
      }
      List<String> selectedTags = [];
      for (var tag in tagsCount.keys) {
        if (tag != '9gag' && tag != 'video') {
          if (tagsCount[tag]! >= 3) {
            selectedTags.add(tag);
          }
        }
      }
      if (selectedTags.length > 7) {
        selectedTags = selectedTags.sublist(0, 7);
      }

      List<Widget> storyWidgetChildren = [];
      for (var tag in selectedTags) {
        var meme = stories.firstWhere(
            (element) => _ifContainsTag(tags: element.tags, ktag: tag));
        storyWidgetChildren.add(
          GestureDetector(
            onTap: () {
              Get.to(StoryPlayer(
                tag: tag,
              ));
              StoriesController storiesController = Get.find();
              storiesController.getStoryByTag(tag: tag);
            },
            child: SizedBox(
              width: Get.height * 0.1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      strokeWidth: 1.5,
                      dashPattern: const [8, 3, 8, 3],
                      borderType: BorderType.Circle,
                      color: Get.isDarkMode ? Colors.white : Colors.deepPurple,
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: Get.height * 0.035,
                        backgroundImage: NetworkImage(meme.url),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        tag == 'news' ? 'Latest' : tag,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          color:
                              Get.isDarkMode ? Colors.white : Colors.deepPurple,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      }
      Widget tempStoryWidget = ListView(
        physics: const BouncingScrollPhysics(),
        children: storyWidgetChildren,
        scrollDirection: Axis.horizontal,
      );
      // ignore: sized_box_for_whitespace
      storiesWidget.value = Container(
        child: tempStoryWidget,
        height: Get.height * 0.1,
      );
    } catch (e) {
      storiesWidget.value = Container();
      debugPrint(e.toString());
    }
  }

  bool _ifContainsTag({required var tags, required var ktag}) {
    var atagsList = [];
    var result = false;
    if (tags != null) {
      for (var tag in tags) {
        if (tag['key'] != null) {
          atagsList.add(tag['key']);
        }
      }
    }
    for (var atag in atagsList) {
      if (atag == ktag) {
        result = true;
      }
    }
    return result;
  }
}