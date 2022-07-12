// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/pages/stories/widget/story_finished.dart';
import 'package:chomu/pages/stories/widget/story_page.dart';
import 'package:chomu/pages/stories/widget/video_story_page.dart';
import '../../ads/ads_helper.dart';
import '../../app/app.dart';
import '../../app/controllers/firebase_controller.dart';
import '../../common/enum/status.dart';
import '../error/error.dart';
import '../splash/splash.dart';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({Key? key}) : super(key: key);

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage> {
  // COMPLETE: Add _bannerAd
  late BannerAd _bannerAd;

  // COMPLETE: Add _isBannerAdReady
  bool _isBannerAdReady = false;
  bool _isBannerAdFailed = false;
  // loading ad
  setUpAds() {
    // COMPLETE: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          _isBannerAdFailed = true;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  initState() {
    super.initState();
    FirebaseController firebaseController = Get.find();
    firebaseController.logCurrentScreen(
        screenClass: 'Stories', screenName: 'Stories');
    setUpAds();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        HomeController homeController = Get.find();
        homeController.changeCurrentPage(0);
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Ad Widget
              SizedBox(
                height: 55,
                width: 320,
                child: _isBannerAdReady
                    ? Center(child: AdWidget(ad: _bannerAd))
                    : !_isBannerAdFailed
                        ? const LinearProgressIndicator(
                            backgroundColor: Colors.deepPurple,
                          )
                        : Container(
                            color: Colors.black,
                          ),
              ),
              const Expanded(child: StoryPlayer()),
            ],
          )),
    );
  }
}

class StoryPlayer extends GetView<StoriesController> {
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoriesController>(
      init: StoriesController(),
      builder: (controller) => Obx(() {
        switch (controller.status.value) {
          case Status.loading:
            return const Splash();
          case Status.loaded:
            var memes = controller.memes;
            // scroller
            return PageView.builder(
              itemCount: memes.length + 1,
              itemBuilder: (context, index) {
                if (index == memes.length) {
                  return const StoriesFinished();
                } else {
                  var post = memes[index];
                  if (post.type == 'Animated') {
                    return VideoStoryPage(
                      currentPage: index,
                      meme: memes[index],
                      tag: null,
                      pageController: controller.pageController,
                    );
                  } else if (post.type == 'Photo') {
                    return StoryPage(
                      meme: post,
                      pageController: controller.pageController,
                    );
                  } else {
                    return StoryPage(
                      meme: post,
                      pageController: controller.pageController,
                    );
                  }
                }
              },
              scrollDirection: Axis.vertical,
              controller: controller.pageController,
            );
          case Status.error:
            return ErrorScreen(
              error: 'There was a problem while showing the stories',
              onTap: () {
                Get.offAll(const App());
              },
            );
        }
      }),
    );
  }
}
