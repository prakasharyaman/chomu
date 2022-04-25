import 'package:chomu/pages/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/enum/status.dart';
import '../splash/splash.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) => Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            return ProfilePage();
          case Status.error:
            return const Splash();
        }
      }),
    );
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
