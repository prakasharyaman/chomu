// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 🌎 Project imports:
import 'package:chomu/app/controllers/firebase_controller.dart';
import 'package:chomu/pages/home/games/controller/games_page_controller.dart';
import 'package:chomu/pages/home/games/widgets/game_card.dart';

class GameHome extends GetView<GamesPageController> {
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
  FirebaseController firebaseController = Get.find();
  @override
  void initState() {
    super.initState();
    firebaseController.logCurrentScreen(
        screenClass: 'Games', screenName: 'Games');
  }

  @override
  Widget build(BuildContext context) {
    var gameList = gamesPageController.gamesList;
    var playedGamesList = gamesPageController.playedGamesList;
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent])),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  height: height * 0.3,
                  width: width,
                  child: Image.asset(
                    'assets/images/gamesbackground.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: playedGamesList.isNotEmpty,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Played Recently',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            playedGamesList.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      height: 1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate(
                      List.generate(
                        playedGamesList.length,
                        (index) => GameCard(
                          game: playedGamesList[index],
                        ),
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Latest Games',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            gamesPageController.gamesList.isNotEmpty
                ? SliverList(
                    delegate: SliverChildListDelegate(
                      List.generate(
                        gameList.length,
                        (index) => GameCard(
                          game: gameList[index],
                        ),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No Games Available!',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
