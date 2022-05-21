// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/app/controllers/firebase_controller.dart';
import 'package:chomu/common/videoPostWidget/video_post_widget.dart';
import 'package:chomu/pages/error/error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import '../../../../app/app.dart';
import '../../../../common/enum/status.dart';
import '../../../../common/memeWidget/meme_widget.dart';
import '../../../../common/menu/dropdown_menu.dart';
import '../../../../models/meme_model.dart';
import '../../../splash/splash.dart';
import '../../controller/home_controller.dart';
import 'controller/hot_controller.dart';

class Hot extends GetView<HotController> {
  Hot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(screenClass: 'Hot', screenName: 'Hot');
    return GetBuilder<HotController>(
      init: HotController(),
      builder: (controller) => Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            // Get.to(MyHomePage(title: 'sb'));
            return const HotPage();
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

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  final homeController = Get.find<HomeController>();
  HotController controller = Get.find<HotController>();
  late List<Meme> memes;
  bool showReport = false;
  Meme? menuMeme;
  @override
  void initState() {
    super.initState();
    memes = controller.memes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //content
        NestedScrollView(
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
                          color:
                              Get.isDarkMode ? Colors.white : Colors.deepPurple,
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
                          color:
                              Get.isDarkMode ? Colors.white : Colors.deepPurple,
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
              child: InViewNotifierList(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  // ignore: prefer_const_literals_to_create_immutables
                  initialInViewIds: ['0'],
                  isInViewPortCondition: (double deltaTop, double deltaBottom,
                      double viewPortDimension) {
                    return deltaTop < (0.5 * viewPortDimension) &&
                        deltaBottom > (0.5 * viewPortDimension);
                  },
                  itemCount: memes.length + 1,
                  builder: (BuildContext context, int index) {
                    if (index == memes.length) {
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
                      if (memes[index].type == 'Animated') {
                        // animated meme
                        return LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return InViewNotifierWidget(
                              id: '$index',
                              builder: (BuildContext context, bool isInView,
                                  Widget? child) {
                                return VideoPostWidget(
                                  play: isInView,
                                  url: memes[index].videoUrl ?? '',
                                  post: memes[index],
                                  height: Get.height,
                                  menuFunction: () {
                                    setState(() {
                                      menuMeme = memes[index];
                                      showReport = !showReport;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      } else {
                        // image meme
                        return MemeWidget(
                          height: Get.height,
                          menuFunction: () {
                            setState(() {
                              menuMeme = memes[index];
                              showReport = !showReport;
                            });
                          },
                          meme: memes[index],
                        );
                      }
                    }
                  }),
            ),
          ),
        ),
        // drop down menu
        AnimatedPositioned(
            top: showReport == false
                ? MediaQuery.of(context).size.height * 1.5
                : 150,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: DropDownMenu(
                onClose: () {
                  setState(() {
                    showReport = !showReport;
                  });
                },
                meme: menuMeme,
              ),
            ),
            duration: const Duration(milliseconds: 500)),
      ],
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
