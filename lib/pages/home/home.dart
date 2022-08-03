// 🐦 Flutter imports:
import 'package:chomu/pages/home/home_page.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:chomu/pages/feedback/feedback_screen.dart';
import '../feedback/controller/feedback_controller_bindings.dart';
import '../settings/page/settingsPage.dart';
import '../stories/stories_player.dart';
import 'controller/home_controller.dart';
import 'games/games_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var showBadge = true;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const StoryPlayer(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          extendBody: false,
          key: controller.drawerOpenKey,
          body: _widgetOptions.elementAt(controller.currentPage),
          bottomNavigationBar: Visibility(
            visible: controller.currentPage == 1 ? false : true,
            child: Visibility(
              child: BottomNavigationBar(
                onTap: controller.changeCurrentPage,
                currentIndex: controller.currentPage,
                items: const [
                  // home
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow),
                    label: 'Stories',
                  ),
                ],
              ),
            ),
          ),
          drawer: _buildHomeDrawer(),
        );
      },
    );
  }

//home drawer
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

          // games
          ListTile(
            onTap: () {
              Get.to(const GamesPage());
            },
            leading: const Icon(FontAwesomeIcons.gamepad),
            title: const Text('Games'),
          ),
          //profile

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
                  subject: 'Download Chomu 🔥');
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

  void _launchUrl(url) async {
    var _url = Uri.parse(url);

    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
