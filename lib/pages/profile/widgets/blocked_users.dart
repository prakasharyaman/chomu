// ignore_for_file: must_be_immutable

import 'package:chomu/pages/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app.dart';
import '../../../common/enum/status.dart';
import '../../error/error.dart';
import '../../splash/splash.dart';

class BlockedUsers extends StatelessWidget {
  BlockedUsers({Key? key}) : super(key: key);
  ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    var blockedUsers = profileController.blockedUsers;

    return Scaffold(
      body: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) => Obx(() {
          switch (controller.status.value) {
            case Status.loading:
              return const Splash();
            case Status.loaded:
              return Scaffold(
                backgroundColor: Get.isDarkMode
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : const Color.fromARGB(255, 240, 242, 245),
                appBar: AppBar(title: const Text('Blocked Users')),
                body: ListView.builder(
                    itemCount: blockedUsers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                            tileColor:
                                Get.isDarkMode ? Colors.black : Colors.white,
                            leading: const Icon(Icons.person),
                            title: Text(blockedUsers[index]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {
                              Get.defaultDialog(
                                  title: "Unblock User ${blockedUsers[index]}?",
                                  middleText:
                                      "You will be able to view all posts from this user in your feed",
                                  radius: 20,
                                  onConfirm: () {
                                    Navigator.pop(context);
                                    profileController.unblockUser(
                                        userName: blockedUsers[index]);
                                    profileController.prepareProfile();
                                  },
                                  onCancel: () {
                                    Get.back();
                                  });
                            },
                            trailing: const Icon(
                                Icons.remove_circle_outline_rounded)),
                      );
                    }),
              );

            case Status.error:
              return ErrorScreen(
                error: 'There was a problem while showing the Blocked Users',
                onTap: () {
                  Get.offAll(const App());
                },
              );
          }
        }),
      ),
    );
  }
}
