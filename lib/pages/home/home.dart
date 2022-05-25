import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/pages/feedback/feedback_screen.dart';
import 'package:chomu/pages/splash/splash.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../feedback/controller/feedback_controller_bindings.dart';
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
            iconSize: 25,
            onItemSelected: controller.changeCurrentPage,
            items: [
              FlashyTabBarItem(
                icon: Icon(Icons.home_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.deepPurple),
                title: Text(
                  'Home',
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.deepPurple),
                ),
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.play_arrow_rounded),
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
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        'https://i.gifer.com/origin/b8/b842107e63c67d5674d17e0f576274fa_w200.gif'),
                  )),
                  child: Stack(
                    children: const [
                      SizedBox(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Chomu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
                  leading: const Icon(Icons.play_arrow_rounded),
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
                  leading: const Icon(Icons.contact_support),
                  title: const Text('Contact'),
                ),
                // contact , website
                ListTile(
                  onTap: () {
                    Share.share(
                        'Check Out This App Chomu \n https://play.google.com/store/apps/details?id=com.otft.chomu',
                        subject: 'Download Chomu 😂');
                  },
                  leading: const Icon(Icons.share_rounded),
                  title: const Text('Share App'),
                ),
                // contact , website
                ListTile(
                  onTap: () {
                    Get.to(const FeedbackScreen(),
                        binding: FeedBackScreenBindings());
                  },
                  leading: const Icon(Icons.feedback_rounded),
                  title: const Text('Feedback'),
                ),
                const Spacer(),
                // privacy Policy
                GestureDetector(
                  onTap: () {
                    var url = 'https://www.otft.in/chomuprivacypolicy';
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

  void _launchUrl(url) async {
    var _url = Uri.parse(url);

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
