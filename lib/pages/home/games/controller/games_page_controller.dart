import 'package:chomu/models/game_model.dart';
import 'package:chomu/pages/error/error.dart';
import 'package:chomu/pages/home/controller/home_controller.dart';
import 'package:chomu/pages/home/games/games_page.dart';
import 'package:chomu/pages/splash/splash.dart';
import 'package:chomu/repository/games_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GamesPageController extends GetxController {
  GamesRepository gamesRepository = GamesRepository();
  List<Game> gamesList = [];
  List<Game> playedGamesList = [];
  String errorMessage = '';
  HomeController homeController = Get.find();
  // ignore: prefer_const_constructors, avoid_unnecessary_containers
  var gamePage = Container(
    child: const Splash(),
  ).obs;

  @override
  void onInit() {
    initiateGamePage();
    super.onInit();
  }

  initiateGamePage() async {
    bool ok = await gamesRepository.getGamesFromCloud();
    if (ok) {
      gamesList = gamesRepository.gamesList;
      playedGamesList = gamesRepository.playedGamesList;
      // ignore: avoid_unnecessary_containers
      gamePage.value = Container(
        child: const GamesPage(),
      );
    } else {
      errorMessage = gamesRepository.errorMessage;
      // ignore: avoid_unnecessary_containers
      gamePage.value = Container(
        child: ErrorScreen(
          error: errorMessage,
          onTap: () {
            homeController.changeCurrentPage(1);
          },
        ),
      );
    }
  }
}
