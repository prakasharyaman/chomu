// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

// 🌎 Project imports:
import 'package:chomu/models/game_model.dart';

class GamesRepository {
  String baseUrl = 'https://www.friv.com/';
  String endUrl = '.html';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Game> gamesList = [];
  List<Game> playedGamesList = [];
  String errorMessage = '';
  GetStorage getStorage = GetStorage();
  Future<bool> getGamesFromCloud() async {
    try {
      var gamesRef = await FirebaseFirestore.instance.collection('games').get();
      if (gamesRef.docs.isNotEmpty) {
        for (var gamesSnapshot in gamesRef.docs) {
          var gamesJson = gamesSnapshot.data();
          var gamesSnapshotId = gamesSnapshot.id;
          var game = Game(
            gamesJson['url'],
            gamesJson['name'],
            gamesJson['description'],
            gamesJson['imageUrl'],
            gamesSnapshotId,
            await lastGamePlayed(name: gamesJson['name']),
          );
          gamesList.add(game);
        }
        if (gamesList.isNotEmpty) {
          var gameNameList = [];
          for (var game in gamesList) {
            gameNameList.add(game.name);
          }
          gameNameList.toSet().toList();

          List<Game> clearGameList = [];
          for (var gameName in gameNameList) {
            var game = gamesList.firstWhere((game) => game.name == gameName);
            clearGameList.add(game);
          }
          gamesList = clearGameList;
          // sorting out already played games
          for (var game in gamesList) {
            if (game.lastPlayed != null) {
              playedGamesList.add(game);
            }
          }
          var cleanNamePlayedList = [];
          List<Game> cleanPlayedList = [];
          for (var game in playedGamesList) {
            cleanNamePlayedList.add(game.name);
          }
          cleanNamePlayedList.toSet().toList();
          for (var gameName in cleanNamePlayedList) {
            var game =
                playedGamesList.firstWhere((game) => game.name == gameName);
            cleanPlayedList.add(game);
          }
          playedGamesList.clear();
          playedGamesList = cleanPlayedList;
          // removing played games from new games list
          gamesList.removeWhere((element) => playedGamesList.contains(element));
          // sorting played games
          playedGamesList
              .sort((a, b) => b.lastPlayed!.compareTo(a.lastPlayed!));
        } else {
          throw Exception('No games found');
        }
      } else {
        throw Exception('No games found');
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      errorMessage = e.toString();
      return false;
    }
  }

  Future<dynamic> lastGamePlayed({required String name}) async {
    var lastGamePlayed = getStorage.read(name + '_' + 'lastGamePlayed');
    if (lastGamePlayed == null) {
      return null;
    } else {
      lastGamePlayed = DateTime.parse(lastGamePlayed);
      return lastGamePlayed;
    }
  }
}
