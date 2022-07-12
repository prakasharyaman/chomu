// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/models/game_model.dart';
import 'package:chomu/pages/home/games/widgets/game_play_view.dart';

class GameCard extends StatelessWidget {
  const GameCard({Key? key, required this.game}) : super(key: key);
  final Game game;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(GamePlayView(game: game));
        },
        child: Container(
          height: 100,
          width: 360,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                onError: (o, e) {
                  debugPrint(e.toString());
                },
                image: CachedNetworkImageProvider(game.imageUrl),
                fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
            color: Colors.deepPurple,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.deepPurple])),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    game.name,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//  Image(
//           fit: BoxFit.cover,
//           image: NetworkImage(game.imageUrl),
//           loadingBuilder: (BuildContext context, Widget child,
//               ImageChunkEvent? loadingProgress) {
//             if (loadingProgress == null) {
//               return child;
//             }
//             return SizedBox(
//               child: Center(
//                   child: CircularProgressIndicator(
//                 color: Colors.white,
//                 value: loadingProgress.expectedTotalBytes != null
//                     ? loadingProgress.cumulativeBytesLoaded /
//                         loadingProgress.expectedTotalBytes!
//                     : null,
//               )),
//             );
//           },
//           errorBuilder: (BuildContext context, Object object,
//               StackTrace? stackTrace) {
//             return const SizedBox(
//               child: Center(
//                 child: Icon(
//                   Icons.error,
//                 ),
//               ),
//             );
//           },
//         ),
