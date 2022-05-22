import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../ads_helper.dart';

// cannot get it right

// uggggh
class StoriesAd extends StatefulWidget {
  const StoriesAd({Key? key}) : super(key: key);

  @override
  State<StoriesAd> createState() => _StoriesAdState();
}

class _StoriesAdState extends State<StoriesAd> {
// COMPLETE: Add _bannerAd
  late BannerAd _bannerAd;

  // COMPLETE: Add _isBannerAdReady
  bool _isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    debugPrint('BigBannerAd initState');
    // COMPLETE: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.fluid,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: Get.height * 0.8,
          width: Get.width,
          child: _isBannerAdReady
              ? AdWidget(ad: _bannerAd)
              : CachedNetworkImage(
                  height: Get.height * 0.8,
                  width: Get.width,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://i.pinimg.com/originals/ef/8b/bd/ef8bbd4554dedcc2fd1fd15ab0ebd7a1.gif',
                  progressIndicatorBuilder: (_, string, progress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    );
                  },
                  errorWidget: (_, string, error) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    );
                  },
                )),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd.dispose();
    super.dispose();
  }
}
