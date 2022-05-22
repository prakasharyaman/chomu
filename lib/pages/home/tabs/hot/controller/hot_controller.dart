import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../common/enum/status.dart';
import '../../../../../models/meme_model.dart';
import '../../../../../repository/meme_repository.dart';

class HotController extends GetxController {
  static HotController hotController = Get.find();
  Rx<Status> status = Status.loading.obs;
  MemeRepository memeRepository = MemeRepository();
  final getStorage = GetStorage();

  String errorMessage = '';
  List<Meme> memes = [];
  @override
  void onInit() {
    super.onInit();

    getMemes();
    // deleteBookMarksList();
  }

// delete bookmarks
  deleteBookMarksList() {
    getStorage.remove('bookMarkMemesList');
    debugPrint('deleted book marks');
  }

// get Memes
  getMemes() async {
    try {
      status.value = Status.loading;
      memes = await memeRepository.getMemes();
      var watchedmemesList = [];
      List<Meme> nineList = [];
      var watchednineList = [];
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
          if (await checkifUserBlocked(username: meme.author)) {
            watchedmemesList.add(meme);
          }
        }
        // check if the nine post has been watched
        for (var ninePost in nineList) {
          if (await checkMemesIfWatched(url: ninePost.url)) {
            watchednineList.add(ninePost);
          }
        }
        // clearing watched memes
        memes.removeWhere((element) => watchedmemesList.contains(element));
        //clearing watched nine posts

        nineList.removeWhere((element) => watchednineList.contains(element));
      }
      if (nineList.length > 5 && memes.length > 15) {
        if (memes.length > 45) {
          memes = memes.sublist(0, 45);
        }
        if (nineList.length > 15) {
          nineList = nineList.sublist(0, 15);
        }
        memes.addAll(nineList);
      }

      if (memes.length > 3) {
        memes.shuffle();
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

  // report meme
  reportMeme({required Meme meme, bool hideSnack = false}) async {
    try {
      await memeRepository.reportMeme(id: meme.id, meme: meme);
      if (!hideSnack) {
        Get.snackbar(
          'Meme Reported',
          'Thank you for reporting this meme',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      if (!hideSnack) {
        Get.snackbar(
          'Uh Oh!',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      debugPrint(e.toString());
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
