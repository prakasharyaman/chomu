import 'package:get/get.dart';

class VolumeController extends GetxController {
  static VolumeController volumeController = Get.find();
  double volume = 0;
  setVolume({required double value}) {
    volume = value;
    update();
  }
}
