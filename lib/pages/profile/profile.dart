import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/models/meme_model.dart';
import 'package:chomu/pages/profile/controller/profile_controller.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/enum/status.dart';
import '../splash/splash.dart';
import 'widgets/book_mark_grid_widget.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(
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
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    var bookmarksList = profileController.bookmarksList;
    return CustomScrollView(
      slivers: [
        // app bar watched
        SliverToBoxAdapter(
          child: Container(
            padding:
                const EdgeInsets.only(right: 8, left: 8.0, top: 15, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // back button
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Profile",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ],
            ),
          ),
        ),
        // total watched memes
        SliverToBoxAdapter(
          child: SizedBox(
            width: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // liquid text
                TextLiquidFill(
                  boxBackgroundColor:
                      Get.isDarkMode ? Colors.black : Colors.white,
                  waveColor: Get.isDarkMode ? Colors.white : Colors.purple,
                  text: '${profileController.totalWatchedMemesLength}',
                  textStyle: const TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 200.0,
                ),
                // total post watched text
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '☝️ Total Post Watched 👍',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
        // book marks
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: const EdgeInsets.all(8),
            child: Text(
              'BookMarks 🔖',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),

        // book marks
        bookmarksList.isNotEmpty
            ? SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 0,
                ),
                delegate: SliverChildListDelegate(
                  List.generate(
                    bookmarksList.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: BookMarkGridWidget(
                        meme: bookmarksList[index],
                      ),
                    ),
                  ),
                ),
              )
            : SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No Bookmarks Yet !',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
      ],
    );
  }
}