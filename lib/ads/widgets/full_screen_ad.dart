import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads_helper.dart';

class FullScreenAd extends StatefulWidget {
  const FullScreenAd({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;

  @override
  State<FullScreenAd> createState() => _FullScreenAdState();
}

class _FullScreenAdState extends State<FullScreenAd> {
// COMPLETE: Add _interstitialAd
  InterstitialAd? _interstitialAd;
  late PageController pageController;
  // COMPLETE: Add _isInterstitialAdReady
  // ignore: unused_field
  bool _isInterstitialAdReady = false;
  @override
  void initState() {
    super.initState();
    pageController = widget.pageController;
    debugPrint('FullScreenAd initState');
    _loadInterstitialAd();
  }

  // COMPLETE: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // ignore: unnecessary_this
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // add on dismissed logic
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }
}
