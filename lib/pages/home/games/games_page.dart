import 'package:chomu/pages/home/games/controller/games_page_controller.dart';
import 'package:chomu/repository/games_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameHome extends StatelessWidget {
  const GameHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: GetBuilder<GamesPageController>(
        builder: (controller) {
          return Obx(() => controller.gamePage.value);
        },
        init: GamesPageController(),
      ),
    );
  }
}

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  GamesPageController gamesPageController = Get.find();
  late WebViewController webViewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(),
    );
  }
}
