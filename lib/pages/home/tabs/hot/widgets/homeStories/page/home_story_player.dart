import 'package:chomu/models/meme_model.dart';
import 'package:chomu/pages/error/error.dart';
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:chomu/repository/stories_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:story_view/story_view.dart';

class HomeStoryPlayer extends StatefulWidget {
  const HomeStoryPlayer({Key? key, required this.tag}) : super(key: key);
  final String tag;
  @override
  State<HomeStoryPlayer> createState() => _HomeStoryPlayerState();
}

class _HomeStoryPlayerState extends State<HomeStoryPlayer> {
  final StoryController controller = StoryController();
  late String tag;
  final getStorage = GetStorage();
  List<StoryItem> stories = [];
  List<Meme> memes = [];
  StoriesRepository storiesRepository = StoriesRepository();
  @override
  void initState() {
    tag = widget.tag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(tag == 'news' ? 'Latest' : tag.toString().toUpperCase()),
        // ),
        body: FutureBuilder(
      future: getStories(tag: tag),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (stories.isEmpty) {
            return ErrorScreen(
                error: 'Stories not found !',
                onTap: () {
                  Get.back();
                });
          } else {
            return StoryView(
              controller: controller,
              storyItems: stories,
              onStoryShow: (s) {
                s.shown == true;
              },
              onComplete: () {
                HotController hotController = Get.find();
                for (var meme in memes) {
                  hotController.saveMemeAsWatched(url: meme.url);
                }
                debugPrint('watched a total of : ${memes.length} posts');
                Get.back();
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              inline: false,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ),
          );
        }
      },
    ));
  }

  getStories({required String tag}) async {
    bool isDataReady = false;
    try {
      await getStoryByTag(tag: tag);
    } catch (e) {
      debugPrint(e.toString());
      isDataReady = false;
    }
    return isDataReady;
  }

  // function for checking if it contains tags
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

// home stories getter by tag
  getStoryByTag({required String tag}) async {
    debugPrint('getting stories by tag : $tag');
    // sorting the list
    List<Meme> watchedmemesList = [];
    List<Meme> animatedTagList = [];
    List<Meme> tagList = [];
    List<String> titleList = [];

    //getting all news posts
    memes = await storiesRepository.getNewsPosts();
    List<Meme> videoMemes = await storiesRepository.getVideoPosts();
    // rm repeated memes
    for (var meme in memes) {
      videoMemes.removeWhere((element) => element.title == meme.title);
    }
    memes = memes + videoMemes;
    // check if the meme has been watched
    for (var meme in memes) {
      if (await checkMemesIfWatched(url: meme.url)) {
        watchedmemesList.add(meme);
      }
      titleList.add(meme.title.toString());
    }

    // removing watched memes from the list
    memes.removeWhere((element) => watchedmemesList.contains(element));
    debugPrint('total posts : ${titleList.length}');
    titleList = titleList.toSet().toList();
    debugPrint('total non repeating posts : ${titleList.length}');
    // clear list from repeating elements
    List<Meme> clearMemes = [];
    // removing repeated titles posts
    for (var title in titleList) {
      var rep = memes.where((element) => element.title == title);
      if (rep.length > 1) {
        clearMemes.add(rep.first);
      } else if (rep.length == 1) {
        clearMemes.add(rep.first);
      }
    }
    memes = clearMemes;
    debugPrint('after removing repeating posts, length is now:${memes.length}');
    // adding news to the list
    for (var meme in memes) {
      if (_ifContainsTag(tags: meme.tags, ktag: tag)) {
        tagList.add(meme);
      }
    }
    // creating animated and non animated lists
    // animated
    for (var animatedPost in tagList) {
      if (animatedPost.type == 'Animated') {
        animatedTagList.add(animatedPost);
      }
    }

    memes.removeWhere((element) => animatedTagList.contains(element));
    memes.removeWhere((element) => tagList.contains(element));
    tagList.removeWhere((element) => animatedTagList.contains(element));
    debugPrint('total Animated Posts : ${animatedTagList.length}');

    if (memes.length > 3) {
      memes = animatedTagList + tagList + memes;
      if (memes.length > 10) {
        memes = memes.sublist(0, 10);
      }
      for (var meme in memes) {
        if (meme.type == 'Animated') {
          if (meme.videoUrl != null) {
            if (meme.duration != null && meme.duration != 0) {
              stories.add(StoryItem.pageVideo(meme.videoUrl!,
                  controller: controller,
                  duration: Duration(seconds: meme.duration!),
                  caption: meme.title,
                  imageFit: BoxFit.contain));
            } else {
              debugPrint('duration is null');
              stories.add(StoryItem.pageVideo(meme.videoUrl!,
                  controller: controller,
                  duration: const Duration(seconds: 5),
                  caption: meme.title,
                  imageFit: BoxFit.contain));
            }
          }
        } else if (meme.type != 'Animated' && meme.type != 'Video') {
          stories.add(StoryItem.pageImage(
              url: meme.url,
              duration: const Duration(seconds: 6),
              controller: controller,
              caption: meme.title,
              imageFit: BoxFit.contain));
        }
      }
    } else {
      memes.clear();
      stories.clear();
    }
  }

// check memes if they are watched then remove them
  Future<bool> checkMemesIfWatched({required String url}) async {
    var watchedMemeList = await getStorage.read('watchedMemesList');
    if (watchedMemeList == null) {
      watchedMemeList = [];
    } else {
      watchedMemeList = watchedMemeList as List<dynamic>;
    }

    // check if the meme is watched
    try {
      if (watchedMemeList.contains(url)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
