// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/pages/feedback/controller/feedback_controller.dart';

class FeedBackScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FeedbackController>(FeedbackController());
  }
}
