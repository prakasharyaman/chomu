// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import '../ads_helper.dart';

class BigBannerAd extends StatefulWidget {
  const BigBannerAd({Key? key}) : super(key: key);

  @override
  State<BigBannerAd> createState() => _BigBannerAdState();
}

class _BigBannerAdState extends State<BigBannerAd> {
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
      size: AdSize.mediumRectangle,
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
          height: 250,
          width: 300,
          child: _isBannerAdReady
              ? Center(child: AdWidget(ad: _bannerAd))
              : CachedNetworkImage(
                  height: 300,
                  width: 250,
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
