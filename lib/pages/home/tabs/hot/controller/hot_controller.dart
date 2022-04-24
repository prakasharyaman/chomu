import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../common/enum/status.dart';
import '../../../../../models/meme_model.dart';
import '../../../../../repository/meme_repository.dart';

class HotController extends GetxController {
  static HotController freshController = Get.find();
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
}
