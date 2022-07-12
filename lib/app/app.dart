// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/app/controllers/firebase_controller.dart';
import '../pages/home/home.dart';
import '../pages/splash/splash.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(
      builder: (controller) => Obx(
        () => controller.userModel.value.id == null
            ? const Splash()
            : const Home(),
      ),
    );
  }
}
