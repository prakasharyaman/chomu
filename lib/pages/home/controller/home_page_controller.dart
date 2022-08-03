import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../common/enum/status.dart';
import '../../../models/reddit_post.dart';

class HomePageController extends GetxController {
  Rx<Status> homePageStatus = Status.loading.obs;
  DataRepository dataRepository = DataRepository();
  final getStorage = GetStorage();
  HomeController homeController = Get.find();
  String errorMessage = '';
  List<RedditPost> redditPosts = [];
  Rx<bool> showDropDown = false.obs;
  @override
  void onInit() {
    super.onInit();

    getHomePagePosts();
    // deleteBookMarksList();
  }

// delete bookmarks
  deleteBookMarksList() {
    getStorage.remove('bookMarkMemesList');
    debugPrint('deleted book marks');
  }

// get reddit posts
  getHomePagePosts() async {
    try {
      homePageStatus.value = Status.loading;
      redditPosts = await dataRepository.getRedditPosts();
      var watchedRedditPosts = [];

      // check if the meme has been watched
      for (var redditPost in redditPosts) {
        if (await checkRedditPostIfWatched(url: redditPost.url)) {
          watchedRedditPosts.add(redditPost);
        }
      }
      // check if the user has been blocked
      for (var redditPost in redditPosts) {
        if (await checkifUserBlocked(username: redditPost.author)) {
          watchedRedditPosts.add(redditPost);
        }
      }
      // clearing watched memes
      redditPosts
          .removeWhere((element) => watchedRedditPosts.contains(element));

      if (redditPosts.length > 3) {
        if (redditPosts.length > 55) {
          redditPosts = redditPosts.sublist(0, 55);
        }
        homePageStatus.value = Status.loaded;
        update();
      } else {
        throw Exception('No More Memes Found');
      }
    } catch (e) {
      homePageStatus.value == Status.error;
      errorMessage = e.toString();
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// check memes if they are watched then remove them
  Future<bool> checkRedditPostIfWatched({required String url}) async {
    var watchedRedditPostList = await getStorage.read('watchedRedditPostList');
    if (watchedRedditPostList == null) {
      watchedRedditPostList = [];
    } else {
      watchedRedditPostList = watchedRedditPostList as List<dynamic>;
    }

    // check if the meme is watched
    try {
      if (watchedRedditPostList.contains(url)) {
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
        if (username == 'ChomuKing') {
          return false;
        } else {
          return true;
        }
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
  saveRedditPostAsWatched({required String url}) async {
    var watchedRedditPostList = await getStorage.read('watchedRedditPostList');
    if (watchedRedditPostList == null) {
      watchedRedditPostList = [];
    } else {
      watchedRedditPostList = watchedRedditPostList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      // check to see if it already exists
      if (!watchedRedditPostList.contains(url)) {
        watchedRedditPostList.add(url);
        await getStorage.write('watchedRedditPostList', watchedRedditPostList);
      }
    } catch (e) {
      // throw Exception('Error Saving Meme');
    }
  }

  // report meme
  reportMeme({required RedditPost redditPost, bool hideSnack = false}) async {
    try {
      await saveRedditPostAsWatched(url: redditPost.url);
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

}
