import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/home/widgets/meme_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../splash/splash.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Chomu'),
        leading: Icon(Icons.menu),
      ),
      body: Container(
        decoration: kHomeBoxDecoration(),
        margin: const EdgeInsets.only(left: 1, right: 1),
        child: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) => Obx(() {
            switch (controller.status.value) {
              case Status.loading:
                return const Splash();
              case Status.loaded:
                return RefreshIndicator(
                  displacement: 80,
                  onRefresh: () async {
                    controller.getMemes();
                  },
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.memes.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        return MemeWidget(
                          meme: controller.memes[index],
                          height: height,
                        );
                      }),
                );

              case Status.error:
                return Center(
                  child: Text('Error'),
                );
            }
          }),
        ),
      ),
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
                  Color.fromARGB(255, 251, 252, 253),
                  Color.fromARGB(255, 244, 247, 250),
                ],
              ));
  }
}
