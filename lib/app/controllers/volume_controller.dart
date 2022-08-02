// 📦 Package imports:
import 'package:get/get.dart';

class VolumeController extends GetxController {
  bool isMute = true;
  setVolume({required bool value}) {
    isMute = value;
    update();
  }
}
