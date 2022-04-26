import 'package:chomu/pages/splash/splash.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile/bindings/profile_bindings.dart';
import '../profile/profile.dart';
import '../settings/page/settingsPage.dart';
import '../stories/stories_player.dart';
import 'controller/home_controller.dart';
import 'tabs/hot/hot.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          key: controller.drawerOpenKey,
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
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Container(
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                //home Widget
                ListTile(
                  onTap: () {
                    Get.back();
                  },
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                ),

                //stories
                ListTile(
                  onTap: () {
                    Get.to(const StoryPlayer());
                  },
                  leading: const Icon(Icons.amp_stories),
                  title: const Text('Stories'),
                ),
                //profile
                ListTile(
                  onTap: () {
                    Get.to(const Profile(), binding: ProfileBindings());
                  },
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Account'),
                ),
                //settings
                ListTile(
                  onTap: () {
                    Get.to(const SettingsPage());
                  },
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                ),

                // contact , website
                ListTile(
                  onTap: () {
                    var url = 'mailto:info.outfitindia@gmail.com';
                    _launchUrl(url);
                  },
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact'),
                ),
                // contact , website
                ListTile(
                  onTap: () {
                    Share.share(
                        'Check Out This App Chomu \n https://play.google.com/store/apps/details?id=com.android.chomu',
                        subject: 'Download Chomu 😂');
                  },
                  leading: const Icon(Icons.share_rounded),
                  title: const Text('Share App'),
                ),

                const Spacer(),
                // privacy Policy
                GestureDetector(
                  onTap: () {
                    var url =
                        'https://pages.flycricket.io/chomu-0/privacy.html';
                    _launchUrl(url);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchUrl(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
