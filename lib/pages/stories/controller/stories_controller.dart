// 🎯 Dart imports:
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:chomu/models/nine_post.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

// 🌎 Project imports:
import '../../../common/enum/status.dart';
import '../../../repository/data_repository.dart';

class StoriesController extends GetxController {
  static StoriesController storiesController = Get.find();
  Rx<Status> storiesStatus = Status.loading.obs;
  DataRepository dataRepository = DataRepository();
  GetStorage getStorage = GetStorage();
  late PageController pageController;
  String errorMessage = '';
  // volume controls
  var volume = 0;
  List<NinePost> ninePosts = [];
  // keeping track of the current index
  int focusedindex = 0;
  // storing the list of video url
  List<String> urls = [];
  // controllers to access the video player controller for a particular video url
  var controllers = {};
  @override
  void onInit() {
    super.onInit();
    pageController =
        PageController(viewportFraction: 1, keepPage: true, initialPage: 0);
    getNinePosts();
  }

// get nine posts
  getNinePosts() async {
    try {
      storiesStatus.value = Status.loading;
      update();
      ninePosts.clear();
      ninePosts = await dataRepository.getNinePosts();
      // watched list
      List<NinePost> watchedNinePosts = [];
      // animated list
      List<NinePost> animatedNinePosts = [];
      // non animated list
      List<NinePost> nonAnimatedPosts = [];
      // check if the post is watched and if they are animated or not
      for (var ninePost in ninePosts) {
        if (await checkPostIfWatched(url: ninePost.images.image460.url)) {
          watchedNinePosts.add(ninePost);
        }
        if (ninePost.type == 'Animated') {
          animatedNinePosts.add(ninePost);
        } else {
          nonAnimatedPosts.add(ninePost);
        }
      }
      // sorting by time
      animatedNinePosts.sort((a, b) => b.creationTs.compareTo(a.creationTs));
      nonAnimatedPosts.sort((a, b) => b.creationTs.compareTo(a.creationTs));
      // empying the ninePosts list
      ninePosts.clear();
      // adding the watched and animated posts to the list
      ninePosts = animatedNinePosts;
      ninePosts.addAll(nonAnimatedPosts);
      // remove nine posts that are watched
      ninePosts.removeWhere((element) => watchedNinePosts.contains(element));
      // add urls to list
      for (var ninePost in ninePosts) {
        if (ninePost.type == 'Animated') {
          urls.add(ninePost.images.image460sv!.url);
        }
      }

      /// Initialize 1st video
      await _initializeControllerAtIndex(0);

      /// Play 1st video
      _playControllerAtIndex(0);

      /// Initialize 2nd video
      await _initializeControllerAtIndex(1);
      if (ninePosts.length > 2) {
        storiesStatus.value = Status.loaded;
        update();
      } else {
        throw Exception('No Stories Found !');
      }
    } catch (e) {
      storiesStatus.value = Status.error;
      update();
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint(e.toString());
    }
  }

// check memes if they are watched then remove them
  Future<bool> checkPostIfWatched({required String url}) async {
    var watchedNinePostsList = await getStorage.read('watchedNinePostsList');
    if (watchedNinePostsList == null) {
      watchedNinePostsList = [];
    } else {
      watchedNinePostsList = watchedNinePostsList as List<dynamic>;
    }

    // check if the meme is watched
    try {
      if (watchedNinePostsList.contains(url)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

// check if user has blocked other user
  checkifUserBlocked({required String username}) async {
    var blockedUserList = await getStorage.read('blockedUserList');
    if (blockedUserList == null) {
      blockedUserList = [];
    } else {
      blockedUserList = blockedUserList as List<dynamic>;
    }

    // check if the meme is watched
    try {
      if (blockedUserList.contains(username)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //block user
  blockUser({required String userName}) async {
    var blockedUserList = await getStorage.read('blockedUserList');

    if (blockedUserList == null) {
      blockedUserList = [];
    } else {
      blockedUserList = blockedUserList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      if (!blockedUserList.contains(userName)) {
        blockedUserList.add(userName);
        await getStorage.write('blockedUserList', blockedUserList);
        Get.snackbar(
          'User Blocked',
          'You won\'t see posts from $userName \n you can unblock him from the profile page',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'User Already Blocked',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error Blocking User',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //unblock user
  unblockUser({required String userName}) async {
    var blockedUserList = await getStorage.read('blockedUserList');

    if (blockedUserList == null) {
      blockedUserList = [];
    } else {
      blockedUserList = blockedUserList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      if (blockedUserList.contains(userName)) {
        blockedUserList.remove(userName);
        await getStorage.write('blockedUserList', blockedUserList);
        Get.snackbar(
          'User Ubnlocked',
          'You will see posts from $userName \n you can block him again from the posts',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error Unblocking User !',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// storage
  savePostAsWatched({required String url}) async {
    var watchedNinePostsList = await getStorage.read('watchedNinePostsList');
    if (watchedNinePostsList == null) {
      watchedNinePostsList = [];
    } else {
      watchedNinePostsList = watchedNinePostsList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      // check to see if it already exists
      if (!watchedNinePostsList.contains(url)) {
        watchedNinePostsList.add(url);
        await getStorage.write('watchedNinePostsList', watchedNinePostsList);
      }
    } catch (e) {
      debugPrint('Error Saving Meme');
    }
  }

// download meme
  downloadMemeUrl({required String url, required String fileName}) async {
    try {
      // await memeRepository.downloadMeme(url: url, fileName: fileName);
      Get.snackbar(
        'Download Complete',
        'The file has been saved to your Downloads folder',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // report meme
  reportPost({required NinePost ninePost}) async {
    try {
      await savePostAsWatched(url: ninePost.images.image460.url);
      Get.snackbar(
        'Meme Reported',
        'Thank you for reporting this meme',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// video index changed
  onvideoIndexChanged({required int index}) {
    if (index > focusedindex) {
// play next video
      _playNext(index);
    } else {
// play previous video
      _playPrevious(index);
    }
    focusedindex = index;
  }

  void _playNext(int index) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (urls.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController _controller = VideoPlayerController.network(
        urls[index],
      );

      /// Add to [controllers] list
      controllers[index] = _controller;

      /// Initialize
      await _controller.initialize();
      _controller.setVolume(0);
      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = controllers[index]!;

      /// Play controller
      _controller.play();

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void pauseControllerAtIndex(int index) {
    if (urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = controllers[index]!;

      /// Play controller
      _controller.pause();

      log('🚀🚀🚀 pausing $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController _controller = controllers[index]!;

      /// Pause
      _controller.pause();

      /// Reset postiton to beginning
      _controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? _controller = controllers[index];

      /// Dispose controller
      _controller?.dispose();

      if (_controller != null) {
        controllers.remove(_controller);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  // change volume
  setVolume({required int setVolume}) {
    volume = setVolume;
  }
}
// // same meme as bookmark
//   bookmarkMeme({required Meme meme}) async {
//     var bookMarkMemesList = await getStorage.read('bookMarkMemesList');

//     if (bookMarkMemesList == null) {
//       bookMarkMemesList = [];
//     } else {
//       bookMarkMemesList = bookMarkMemesList as List<dynamic>;
//     }
//     // trying to add a meme that is watched
//     try {
//       String json = jsonEncode(meme,
//           toEncodable: (meme) => meme is Meme
//               ? Meme.toJson(meme)
//               : throw UnsupportedError('Cannot save the meme'));
//       bookMarkMemesList.add(json);
//       await getStorage.write('bookMarkMemesList', bookMarkMemesList);
//       Get.snackbar(
//         'Post Bookmarked',
//         'You can view your bookmarks in the Profiles tab',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       errorMessage = e.toString();
//       Get.snackbar(
//         'Error Saving Meme!',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

// // remove meme as bookmark
//   removeBookmarkMeme({required Meme meme}) async {
//     var bookMarkMemesList = await getStorage.read('bookMarkMemesList');

//     if (bookMarkMemesList == null) {
//       bookMarkMemesList = [];
//     } else {
//       bookMarkMemesList = bookMarkMemesList as List<dynamic>;
//     }
//     // trying to add a meme that is watched
//     try {
//       String json = jsonEncode(meme,
//           toEncodable: (meme) => meme is Meme
//               ? Meme.toJson(meme)
//               : throw UnsupportedError('Cannot remove the post'));
//       if (bookMarkMemesList.contains(json)) {
//         bookMarkMemesList.remove(json);
//         await getStorage.write('bookMarkMemesList', bookMarkMemesList);
//         Get.snackbar(
//           'Post Bookmarked Removed',
//           'We have removed the post from your bookmarks',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       errorMessage = e.toString();
//       Get.snackbar(
//         'Error Removing Meme!',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
