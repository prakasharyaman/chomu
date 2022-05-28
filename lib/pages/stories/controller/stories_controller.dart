import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/enum/status.dart';
import '../../../models/meme_model.dart';
import '../../../repository/meme_repository.dart';
import '../../../repository/stories_repository.dart';

class StoriesController extends GetxController {
  StoriesRepository storiesRepository = StoriesRepository();
  final String? tag;
  static StoriesController storiesController = Get.find();
  Rx<Status> status = Status.loading.obs;
  MemeRepository memeRepository = MemeRepository();
  final getStorage = GetStorage();
  PageController pageController = PageController();
  String errorMessage = '';
  List<Meme> memes = [];

  StoriesController({this.tag});
  @override
  void onInit() {
    super.onInit();
    getMemes();
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
    try {
      status.value = Status.loading;
      // cleaning the list
      memes.clear();
      List<Meme> tempNewsPosts = await storiesRepository.getNewsPosts();
      List<Meme> tempVideoList = await storiesRepository.getVideoPosts();
      debugPrint(tempVideoList.length.toString());
      // cleaning repeating elements
      // since tag are different , the object is different so , we have to do it like this
      tempVideoList.removeWhere((element) {
        var rxb = tempNewsPosts
            .where((tempNewsPost) => tempNewsPost.title == element.title);
        if (rxb.length > 1) {
          return true;
        } else {
          return false;
        }
      });
      debugPrint(tempVideoList.length.toString());
      // adding news to the list
      memes.addAll(tempNewsPosts);
      // adding videos to the list
      memes.addAll(tempVideoList);
      // sorting the list
      List<Meme> watchedmemesList = [];
      List<Meme> animatedMemesList = [];
      List<Meme> nonAnimatedMemesList = [];
      // check if the meme has been watched
      for (var meme in memes) {
        if (await checkMemesIfWatched(url: meme.url)) {
          watchedmemesList.add(meme);
        }
      }
      // removing watched memes from the list
      memes.removeWhere((element) => watchedmemesList.contains(element));

      // creating animated and non animated lists
      // animated
      for (var animatedPost in memes) {
        if (animatedPost.type == 'Animated') {
          animatedMemesList.add(animatedPost);
        }
      }
      debugPrint('total Animated Posts : ${animatedMemesList.length}');
      // non animated
      for (var nonAnimatedPost in memes) {
        if (nonAnimatedPost.type != 'Animated') {
          nonAnimatedMemesList.add(nonAnimatedPost);
        }
      }
      debugPrint('total NON-Animated Posts : ${nonAnimatedMemesList.length}');

      if (memes.length > 3) {
        // List<Meme> tempMemesList = memes;
        List<Meme> tagList = [];
        // checking for animated tags
        for (var tempMeme in animatedMemesList) {
          if (tempMeme.tags != null) {
            if (_ifContainsTag(tags: tempMeme.tags, ktag: tag)) {
              tagList.add(tempMeme);
            }
          }
        }
        debugPrint('total, animated tag Posts : ${tagList.length}');
        if (tagList.length < 2) {
          debugPrint('Not enough animated posts');
          // checking for non animated tags
          for (var tempMeme in nonAnimatedMemesList) {
            if (tempMeme.tags != null) {
              if (_ifContainsTag(tags: tempMeme.tags, ktag: tag)) {
                tagList.add(tempMeme);
              }
            }
          }
        }
        if (tagList.length > 1) {
          debugPrint('Cutting the list');
          var bList = tagList.sublist(0, 1);
          tagList.clear();
          tagList.addAll(bList);
        }
        debugPrint('total tag Posts : ${tagList.length}');
        animatedMemesList.removeWhere((element) => tagList.contains(element));
        nonAnimatedMemesList
            .removeWhere((element) => tagList.contains(element));
        debugPrint('total animated posts ${animatedMemesList.length}');
        //clearing memes once again to sort
        memes.clear();
        // creating final list
        memes.addAll(tagList);
        memes.addAll(animatedMemesList);
        memes.addAll(nonAnimatedMemesList);

        if (memes.length > 50) {
          memes = memes.sublist(0, 50);
        }

        status.value = Status.loaded;
      } else {
        throw Exception('No More Posts Found');
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

        if (memes.length > 50) {
          memes = memes.sublist(0, 50);
        }

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
      // throw Exception('Error Saving Meme');
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
}
