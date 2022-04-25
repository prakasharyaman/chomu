import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/pages/profile/widgets/bookmark_meme_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: CachedNetworkImage(
          imageUrl: meme.url,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}
