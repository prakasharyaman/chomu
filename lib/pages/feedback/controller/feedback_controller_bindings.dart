import 'package:chomu/pages/feedback/controller/feedback_controller.dart';
import 'package:get/get.dart';

class FeedBackScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FeedbackController>(FeedbackController());
  }
}
