import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/pages/feedback/feedback_screen.dart';
import 'package:chomu/pages/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../feedback/controller/feedback_controller_bindings.dart';
import '../profile/bindings/profile_bindings.dart';
import '../profile/profile.dart';
import '../settings/page/settingsPage.dart';
import '../stories/stories_player.dart';
import 'controller/home_controller.dart';
import 'tabs/hot/hot.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var showBadge = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          extendBody: false,
          key: controller.drawerOpenKey,
          body: IndexedStack(
            children: [Hot(), const Splash(), const Splash()],
            index: controller.currentPage,
          ),
          bottomNavigationBar: Hidable(
              controller: controller.scrollController,
              size: 70,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(1, 2))
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 10,
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            tooltip: 'Home',
                            onPressed: () {},
                            icon: Icon(
                              Icons.home_rounded,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.deepPurple,
                              size: 30,
                            )),
                        IconButton(
                            tooltip: 'Stories',
                            onPressed: () {
                              setState(() {
                                showBadge = false;
                              });
                              controller.changeCurrentPage(1);
                            },
                            icon: Badge(
                              badgeColor: Colors.deepPurple,
                              animationType: BadgeAnimationType.scale,
                              showBadge: controller.showBadge.value,
                              badgeContent: Text(
                                controller
                                    .generateRandomBadgeNumber()
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.grey,
                                size: 35,
                              ),
                            )),
                        IconButton(
                            tooltip: 'Profile',
                            onPressed: () {
                              controller.changeCurrentPage(2);
                            },
                            icon: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
                ),
              )),
          drawer: _buildHomeDrawer(),
        );
      },
    );
  }

  Drawer _buildHomeDrawer() {
    return Drawer(
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
              Get.to(const FeedbackScreen(), binding: FeedBackScreenBindings());
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
    );
  }
// FlashyTabBar(
//               selectedIndex: controller.currentPage,
//               showElevation: true,
//               iconSize: 25,
//               onItemSelected: controller.changeCurrentPage,
//               items: [
//                 FlashyTabBarItem(
//                   icon: Icon(Icons.home_rounded,
//                       color: Get.isDarkMode ? Colors.white : Colors.deepPurple),
//                   title: Text(
//                     'Home',
//                     style: TextStyle(
//                         color:
//                             Get.isDarkMode ? Colors.white : Colors.deepPurple),
//                   ),
//                 ),
//                 FlashyTabBarItem(
//                   icon: const Icon(Icons.play_arrow_rounded),
//                   title: const Text('Stories'),
//                 ),
//                 FlashyTabBarItem(
//                   icon: const Icon(Icons.person_rounded),
//                   title: const Text('Account'),
//                 ),
//               ],
//             ),

  void _launchUrl(url) async {
    var _url = Uri.parse(url);

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}


// BottomNavigationBar(
//                 elevation: 5,
//                 iconSize: 26,
//                 items: <BottomNavigationBarItem>[
//                   const BottomNavigationBarItem(
//                       icon: Icon(Icons.home_rounded), label: ''),
//                   BottomNavigationBarItem(
//                       icon: Badge(
//                         child: const Icon(Icons.play_arrow_rounded),
//                         badgeContent: Text(
//                             controller.generateRandomBadgeNumber().toString()),
//                       ),
//                       label: ''),
//                   const BottomNavigationBarItem(
//                       icon: Icon(Icons.person), label: ''),
//                 ],
//                 onTap: controller.changeCurrentPage,
//                 currentIndex: controller.currentPage,
//               )),
       