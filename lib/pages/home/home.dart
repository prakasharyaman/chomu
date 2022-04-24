import 'package:chomu/pages/splash/splash.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/home_controller.dart';
import 'tabs/hot/hot.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            children: [Hot(), const Splash(), const Splash()],
            index: controller.currentPage,
          ),
          bottomNavigationBar: FlashyTabBar(
            selectedIndex: controller.currentPage,
            showElevation: true,
            onItemSelected: controller.changeCurrentPage,
            items: [
              FlashyTabBarItem(
                icon: const Icon(Icons.home_rounded),
                title: const Text('Home'),
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.amp_stories),
                title: const Text('Stories'),
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.person_rounded),
                title: const Text('Account'),
              ),
            ],
          ),
        );
      },
    );
  }
}
