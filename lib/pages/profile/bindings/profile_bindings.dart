// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import '../controller/profile_controller.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }
}
