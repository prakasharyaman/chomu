import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/app/controllers/firebase_controller.dart';
import 'package:chomu/pages/error/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/app.dart';
import '../../../../common/enum/status.dart';
import '../../../../common/memeWidget/meme_widget.dart';
import '../../../splash/splash.dart';
import '../../controller/home_controller.dart';
import 'controller/hot_controller.dart';

class Hot extends StatelessWidget {
  Hot({Key? key}) : super(key: key);
  final hotController = Get.find<HotController>();
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(screenClass: 'Hot', screenName: 'Hot');
    return GetBuilder<HotController>(
      init: HotController(),
      builder: (controller) => Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    floating: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // icon
                        GestureDetector(
                          onTap: () {
                            var key = homeController.drawerOpenKey;
                            if (key.currentState != null) {
                              key.currentState!.openDrawer();
                            }
                          },
                          child: const CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                'https://i.gifer.com/origin/b8/b842107e63c67d5674d17e0f576274fa_w200.gif'),
                            radius: 15,
                          ),
                        ),
                        const SizedBox(width: 5),
                        //app Title
                        Text(
                          "CHOMU",
                          style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                        //spacer
                        const Spacer(),
                        // icon search
                        IconButton(
                            onPressed: () {
                              controller.getMemes();
                            },
                            iconSize: 25,
                            icon: Icon(
                              Icons.replay_rounded,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.deepPurple,
                            )),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ];
              },
              body: Container(
                decoration: kHomeBoxDecoration(),
                margin: const EdgeInsets.only(left: 1, right: 1),
                child: RefreshIndicator(
                  displacement: 80,
                  onRefresh: () async {
                    controller.getMemes();
                  },
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: false,
                      itemCount: controller.memes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MemeWidget(
                          meme: controller.memes[index],
                          height: height,
                        );
                      }),
                ),
              ),
            );

          case Status.error:
            return ErrorScreen(
              error: 'There was a problem loading the posts',
              onTap: () {
                Get.offAll(const App());
              },
            );
        }
      }),
    );
  }

  BoxDecoration kHomeBoxDecoration() {
    return BoxDecoration(
        gradient: Get.isDarkMode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 9, 9, 9),
                  Color.fromARGB(255, 8, 8, 8),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 245, 246, 248),
                  Color.fromARGB(255, 244, 247, 250),
                ],
              ));
  }
}
