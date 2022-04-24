import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/enum/status.dart';
import '../../../models/meme_model.dart';
import '../../../repository/meme_repository.dart';

class StoriesController extends GetxController {
  static StoriesController storiesController = Get.find();
  Rx<Status> status = Status.loading.obs;
  MemeRepository memeRepository = MemeRepository();
  final getStorage = GetStorage();

  String errorMessage = '';
  List<Meme> memes = [];
  @override
  void onInit() {
    super.onInit();

    getMemes();
  }

// get Memes
  getMemes() async {
    try {
      status.value = Status.loading;
      memes = await memeRepository.getMemes();
      var watchedmemesList = [];
      if (memes.length > 2) {
        // check if the meme has been watched
        for (var meme in memes) {
          if (await checkMemesIfWatched(url: meme.url)) {
            watchedmemesList.add(meme);
          }
        }
        memes.removeWhere((element) => watchedmemesList.contains(element));
      }
      if (memes.length > 3) {
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
      watchedMemeList.add(url);
      await getStorage.write('watchedMemesList', watchedMemeList);
    } catch (e) {
      throw Exception('Error Saving Meme');
    }
  }

// download meme
  downloadMemeUrl({required String url, required String fileName}) async {
    try {
      await memeRepository.downloadMeme(url: url, fileName: fileName);
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
      bookMarkMemesList.add(meme.toString());
      await getStorage.write('bookMarkMemesList', bookMarkMemesList);
      Get.snackbar(
        'Meme Bookmarked',
        'Thank you for bookmarking this meme',
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
}
