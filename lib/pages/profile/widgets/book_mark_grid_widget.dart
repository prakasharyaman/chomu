// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/pages/profile/widgets/bookmark_meme_page.dart';
import '../../../models/meme_model.dart';

class BookMarkGridWidget extends StatelessWidget {
  const BookMarkGridWidget({
    Key? key,
    required this.meme,
  }) : super(key: key);

  final Meme meme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
          onTap: () {
            Get.to(BookMarkMemePage(meme: meme));
          },
          child: Image(
            image: NetworkImage(meme.url),
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                  child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ));
            },
            errorBuilder:
                (BuildContext context, Object object, StackTrace? stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                ),
              );
            },
          )),
    );
  }
}
// no need to cache this image
// CachedNetworkImage(
//           imageUrl: meme.url,
//           placeholder: (context, url) =>
//               const Center(child: CircularProgressIndicator()),
//           errorWidget: (context, url, error) =>
//               const Center(child: Icon(Icons.error)),
//         ),
