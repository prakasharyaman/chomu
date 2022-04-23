import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../models/meme_model.dart';
import '../controller/home_controller.dart';

class MemeWidget extends StatefulWidget {
  const MemeWidget({Key? key, required this.meme, required this.height})
      : super(key: key);
  final Meme meme;
  final double height;
  @override
  State<MemeWidget> createState() => _MemeWidgetState();
}

class _MemeWidgetState extends State<MemeWidget> {
  late Meme meme;
  late double height;
  bool isPostLiked = false;
  HomeController homeController = Get.find();
  bool isPostBookMarked = false;
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
    height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: VisibilityDetector(
        key: Key(meme.url),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1) {
            homeController.saveMemeAsWatched(url: meme.url);
          }
        },
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              isPostLiked = !isPostLiked;
              meme.ups += isPostLiked ? 1 : -1;
            });
          },
          child: Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author and functions
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      meme.author,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // bookmark button
                  IconButton(
                    icon: Icon(
                      isPostBookMarked
                          ? Icons.bookmark
                          : Icons.bookmark_add_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        isPostBookMarked = !isPostBookMarked;
                      });
                      // TODO : implement bookmark
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
              // title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                child: Text(
                  meme.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Image
              Container(
                height: height * 0.5,
                width: double.infinity,
                color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    width: double.infinity,
                    imageUrl: meme.url,
                    height: height * 0.45,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    )),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                      ),
                    ),
                  ),
                ),
              ),
              // upvote
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(isPostLiked
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined),
                      onPressed: () {
                        setState(() {
                          isPostLiked = !isPostLiked;
                          meme.ups += isPostLiked ? 1 : -1;
                        });
                      },
                    ),
                    Text(
                      NumberFormat.compact().format(meme.ups),
                      style: const TextStyle(fontSize: 10),
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 10),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
