// 🎯 Dart imports:
// ignore: unused_import
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 🌎 Project imports:
import 'package:chomu/app/controllers/firebase_controller.dart';
import 'package:chomu/models/game_model.dart';

class GamePlayView extends StatefulWidget {
  const GamePlayView({
    Key? key,
    required this.game,
  }) : super(key: key);
  final Game game;

  @override
  State<GamePlayView> createState() => _GamePlayViewState();
}

class _GamePlayViewState extends State<GamePlayView> {
  late Game game;
  FirebaseController firebaseController = Get.find();
  final storage = GetStorage();
  var loadingPercentage = 0;
  @override
  void initState() {
    game = widget.game;
    addLastPlayedOn();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    firebaseController.logFirebaseEvent(eventName: game.name.toString());
    super.initState();
  }

// adds to last played list
  addLastPlayedOn() async {
    try {
      await storage.write(
          '${game.name}_lastGamePlayed', DateTime.now().toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          WebView(
            allowsInlineMediaPlayback: true,
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
            onWebResourceError: (error) {
              Get.back();
              Get.snackbar('Oops', 'The Game Failed To Load');
            },
            onPageStarted: (url) {
              if (url == 'https://www.friv.com/') {
                Get.back();
              }
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            //   navigationDelegate: (navigation) {
            //     final host = Uri.parse(navigation.url).host;
            //     if (!host.contains('friv.com')) {
            //       return NavigationDecision.prevent;
            //     }
            //     return NavigationDecision.navigate;
            //   },
            initialUrl: game.url,
            javascriptMode: JavascriptMode.unrestricted,
          ),
          if (loadingPercentage < 100)
            Center(
              child: CircularProgressIndicator(
                value: loadingPercentage / 100.0,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
