// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// 🌎 Project imports:
import 'package:chomu/repository/profile_repository.dart';
import '../../../common/enum/status.dart';
import '../../../models/meme_model.dart';

class ProfileController extends GetxController {
  static ProfileController profileController = Get.find();
  Rx<Status> status = Status.loading.obs;
  ProfileRepository profileRepository = ProfileRepository();
  final getStorage = GetStorage();
  var totalWatchedMemesLength = 0;
  List<Meme> bookmarksList = [];
  var blockedUsers = [];
  @override
  void onInit() {
    super.onInit();
    prepareProfile();
  }

//prepare profile
  prepareProfile() async {
    status.value = Status.loading;

    try {
      totalWatchedMemesLength = await getTotalWatchedMemes();
      bookmarksList = await getBookmarks();
      await getBlockedUsers();

      status.value = Status.loaded;
    } catch (e) {
      Get.snackbar(
        'Uh Oh!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      status.value = Status.error;
    }
  }

//blockedUsers
  getBlockedUsers() async {
    var blockedUserList = await getStorage.read('blockedUserList');

    if (blockedUserList == null) {
      blockedUserList = [];
    } else {
      blockedUserList = blockedUserList as List<dynamic>;
    }
    // trying to add a meme that is watched
    try {
      blockedUsers = blockedUserList;
    } catch (e) {
      Get.snackbar(
        'Error Getting Blocked Users !',
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
          'User Un-Blocked',
          'You will see posts from $userName \n you can block him again from the posts',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Unblocking User !',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

//total memes watched
  getTotalWatchedMemes() async {
    try {
      var totalWatchedMemeList = await getStorage.read('watchedMemesList');
      if (totalWatchedMemeList == null) {
        totalWatchedMemeList = [];
      } else {
        totalWatchedMemeList = totalWatchedMemeList as List<dynamic>;
      }
      return totalWatchedMemeList.length;
    } catch (e) {
      throw Exception('Could not get total watched memes');
    }
  }

  // get bookmarks
  getBookmarks() async {
    var bookMarkMemesList = await getStorage.read('bookMarkMemesList');
    List<Meme> bookMarkMemes = [];
    // trying to add a meme that is watched
    try {
      if (bookMarkMemesList == null) {
        bookMarkMemesList = [];
      } else {
        bookMarkMemesList = bookMarkMemesList.toList();
        for (var meme in bookMarkMemesList) {
          meme = jsonDecode(meme);
          var memeModel = Meme.fromJson(meme);
          bookMarkMemes.add(memeModel);
        }
      }
      return bookMarkMemes;
    } catch (e) {
      Get.snackbar(
        'Error Getting Bookmarks!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    }
  }
}
