import 'package:chomu/repository/profile_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/enum/status.dart';
import '../../../models/meme_model.dart';

class ProfileController extends GetxController {
  static ProfileController profileController = Get.find();
  Rx<Status> status = Status.loading.obs;
  ProfileRepository profileRepository = ProfileRepository();
  final getStorage = GetStorage();
  var totalWatchedMemesLength = 0;
  var getBookmarksList = [];
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
      getBookmarksList = await getBookmarks();
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

    // trying to add a meme that is watched
    try {
      if (bookMarkMemesList == null) {
        bookMarkMemesList = [];
      } else {
        bookMarkMemesList = bookMarkMemesList as List<Meme>;
      }
      return bookMarkMemesList;
    } catch (e) {
      Get.snackbar(
        'Error Getting Bookmarks!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return bookMarkMemesList;
    }
  }
}
