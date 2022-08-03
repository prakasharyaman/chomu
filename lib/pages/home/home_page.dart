import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/common/menu/dropdown_menu.dart';
import 'package:chomu/pages/home/controller/home_page_controller.dart';
import 'package:chomu/pages/home/widgets/reddit_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app.dart';
import '../../common/enum/status.dart';
import '../error/error.dart';
import '../splash/splash.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (controller) => Obx(() {
        switch (controller.homePageStatus.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            return const HomePageBuilder();
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
}

class HomePageBuilder extends GetView<HomePageController> {
  const HomePageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeController = controller.homeController;
    return Scaffold(
      body: NestedScrollView(
        controller: homeController.scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              floating: true,
              title: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        var key = homeController.drawerOpenKey;
                        if (key.currentState != null) {
                          key.currentState!.openDrawer();
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundImage: CachedNetworkImageProvider(
                            'https://i.gifer.com/origin/b8/b842107e63c67d5674d17e0f576274fa_w200.gif',
                            maxHeight: 15),
                      )),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Chomu'),
                  ),
                ],
              ),
              // refresh button
              actions: [
                // icon refresh
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: () {
                    controller.getHomePagePosts();
                  },
                  icon: const Icon(
                    Icons.replay_rounded,
                  ),
                ),
                //menu
              ],
            ),
          ];
        },
        body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            cacheExtent: 10,
            scrollDirection: Axis.vertical,
            itemCount: controller.redditPosts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              var redditList = controller.redditPosts;
              if (index == redditList.length) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    // end of content
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Hit refresh or click on Stories to see more posts',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 1),
                      child: Icon(Icons.arrow_downward_rounded),
                    )
                  ],
                );
              } else {
                // image meme
                return RedditWidget(
                    redditPost: redditList[index],
                    showMenu: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          builder: (_) {
                            return DropDownMenu(
                              redditPost: redditList[index],
                            );
                          });
                    });
              }
            }),
      ),
    );
  }
}
