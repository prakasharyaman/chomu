// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:chomu/ads/widgets/big_banner_ad.dart';
import 'package:chomu/ads/widgets/small_banner_ad.dart';

class AdsController extends GetxController {
  static AdsController adscontroller = Get.find();
  Widget smallBannerAd = Container();
  Widget bigBannerAd = Container();
  @override
  void onInit() {
    // initialise mobile ads
    _initGoogleMobileAds();
    super.onInit();
  }

  _initGoogleMobileAds() async {
    // List<String> testDeviceIds = ['FEF741E573B047C77FD72C70E05CE419'];
    await MobileAds.instance.initialize();
    // thing to add

    // RequestConfiguration configuration =
    //     RequestConfiguration(testDeviceIds: testDeviceIds);
    // MobileAds.instance.updateRequestConfiguration(configuration);

    _buildAds();
  }

  _buildAds() {
    smallBannerAd = const SmallBannerAd();
    bigBannerAd = const BigBannerAd();
  }
}
