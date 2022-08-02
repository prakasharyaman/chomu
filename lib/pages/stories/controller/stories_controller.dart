// 🎯 Dart imports:
import 'dart:convert';
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

// 🌎 Project imports:
import '../../../common/enum/status.dart';
import '../../../models/meme_model.dart';
import '../../../repository/data_repository.dart';
import '../../../repository/meme_repository.dart';

class StoriesController extends GetxController {
  static StoriesController storiesController = Get.find();
  int intialPageIndex = 0;
  Rx<Status> status = Status.loading.obs;
  MemeRepository memeRepository = MemeRepository();
  DataRepository dataRepository = DataRepository();
  final getStorage = GetStorage();
  late PageController pageController;
  String errorMessage = '';
  // volume controls
  var volume = 0;
  List<Meme> memes = [];
  // keeping track of the current index
  int focusedindex = 0;
  // storing the list of video url
  List<String> urls = [];
  // controllers to access the video player controller for a particular video url
  var controllers = {};
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
        viewportFraction: 1, keepPage: true, initialPage: intialPageIndex);
    getMemes();
  }

// get Memes
  getMemes() async {
    try {
      status.value = Status.loading;
      memes = await memeRepository.getMemes();
      var watchedmemesList = [];
      List<Meme> nineList = [];
      List<Meme> watchednineList = [];
      List<Meme> animatedNineList = [];
      List<Meme> nonAnimatedNineList = [];
      nineList = await memeRepository.getNinePosts();

      if (memes.length > 2) {
        // check if the meme has been watched
        for (var meme in memes) {
          if (await checkMemesIfWatched(url: meme.url)) {
            watchedmemesList.add(meme);
          }
        }
        // check if the user has been blocked
        for (var meme in memes) {
          if (await checkifUserBlocked(username: meme.subReddit)) {
            watchedmemesList.add(meme);
          }
        }
        // check if the nine post has been watched
        for (var ninePost in nineList) {
          if (await checkMemesIfWatched(url: ninePost.url)) {
            watchednineList.add(ninePost);
          }
        }
        memes.removeWhere((element) => watchedmemesList.contains(element));
        //clearing watched nine posts
        nineList.removeWhere((element) => watchednineList.contains(element));
      }
      // putting animated memes in the temp list
      for (var ninePost in nineList) {
        if (ninePost.type == 'Animated') {
          animatedNineList.add(ninePost);
        }
      }
      // putting non animated memes in the temp list
      for (var ninePost in nineList) {
        if (ninePost.type != 'Animated') {
          nonAnimatedNineList.add(ninePost);
        }
      }
      if (nineList.length > 3 && memes.length > 3) {
        List<Meme> tempList = animatedNineList;
        tempList.addAll(nonAnimatedNineList);
        nineList = tempList;
        if (memes.length > 30) {
          memes = memes.sublist(0, 30);
        }
        if (nineList.length < 40) {
          memes.addAll(nineList);
          memes.shuffle();
        } else {
          memes = nineList;
        }
        // debugPrint(nineList.length.toString());
        // debugPrint(memes.length.toString());
        for (var mema in memes) {
          urls.add(mema.videoUrl == null ? mema.image460! : mema.videoUrl!);
        }

        /// Initialize 1st video
        await _initializeControllerAtIndex(0);

        /// Play 1st video
        _playControllerAtIndex(0);

        /// Initialize 2nd video
        await _initializeControllerAtIndex(1);
        status.value = Status.loaded;
      } else {
        throw Exception('No More Memes Found');
      }
    } catch (e) {
      status.value == Status.error;
      errorMessage = e.toString();
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
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
  saveMemeAsWatched({required String url}) async {
    var watchedMemeList = await getStorage.read('watchedMemesList');
    if (watchedMemeList == null) {
      watchedMemeList = [];
    } else {
      watchedMemeList = watchedMemeList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      // check to see if it already exists
      if (!watchedMemeList.contains(url)) {
        watchedMemeList.add(url);
        await getStorage.write('watchedMemesList', watchedMemeList);
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
  reportMeme({required Meme meme}) async {
    try {
      await memeRepository.reportMeme(id: meme.id, meme: meme);
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

// same meme as bookmark
  bookmarkMeme({required Meme meme}) async {
    var bookMarkMemesList = await getStorage.read('bookMarkMemesList');

    if (bookMarkMemesList == null) {
      bookMarkMemesList = [];
    } else {
      bookMarkMemesList = bookMarkMemesList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      String json = jsonEncode(meme,
          toEncodable: (meme) => meme is Meme
              ? Meme.toJson(meme)
              : throw UnsupportedError('Cannot save the meme'));
      bookMarkMemesList.add(json);
      await getStorage.write('bookMarkMemesList', bookMarkMemesList);
      Get.snackbar(
        'Post Bookmarked',
        'You can view your bookmarks in the Profiles tab',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error Saving Meme!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// remove meme as bookmark
  removeBookmarkMeme({required Meme meme}) async {
    var bookMarkMemesList = await getStorage.read('bookMarkMemesList');

    if (bookMarkMemesList == null) {
      bookMarkMemesList = [];
    } else {
      bookMarkMemesList = bookMarkMemesList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      String json = jsonEncode(meme,
          toEncodable: (meme) => meme is Meme
              ? Meme.toJson(meme)
              : throw UnsupportedError('Cannot remove the post'));
      if (bookMarkMemesList.contains(json)) {
        bookMarkMemesList.remove(json);
        await getStorage.write('bookMarkMemesList', bookMarkMemesList);
        Get.snackbar(
          'Post Bookmarked Removed',
          'We have removed the post from your bookmarks',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      Get.snackbar(
        'Error Removing Meme!',
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
    intialPageIndex = index;
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
      _controller.setVolume(volume.toDouble());
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
