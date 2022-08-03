import 'package:get/get.dart';
import '../pages/home/controller/home_controller.dart';
import '../services/download_service.dart';
import 'controllers/firebase_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/version_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // put controllers
    // firebase controller to handle login ,analytics ,etc
    Get.put<FirebaseController>(FirebaseController());
    // home controller
    Get.put<HomeController>(HomeController());
    // theme control
    Get.put<ThemeController>(ThemeController());
    // check for latest version
    Get.put<VersionController>(VersionController());
    // download services
    Get.put<FileDownloadService>(FileDownloadService());
  }
}
