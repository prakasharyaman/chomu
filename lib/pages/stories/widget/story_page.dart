import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../models/meme_model.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key, required this.meme}) : super(key: key);
  final Meme meme;
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Meme meme;

  bool isPostLiked = false;

  bool isPostBookMarked = false;
  StoriesController storiesController = Get.find();
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return VisibilityDetector(
      key: Key(meme.url),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.9) {
          storiesController.saveMemeAsWatched(url: meme.url);
        }
      },
      child: Stack(
        children: [
          // Image
          Align(
            child: Container(
              height: height,
              width: width,
              color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CachedNetworkImage(
                  filterQuality: FilterQuality.low,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  imageUrl: meme.url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: height * 0.4,
                    child: Center(
                        child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    )),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    height: height * 0.3,
                    width: double.infinity,
                    child: const Center(
                      child: Icon(
                        Icons.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // back button and dropdown
          Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      ),
                    ),
                    // dropdown
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(Icons.more_vert_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )), // title
          // title and author
          Positioned(
              bottom: 10,
              right: 10,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meme.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(meme.author,
                        style: const TextStyle(
                          fontSize: 10,
                        )),
                  ],
                ),
              )),
          // floating buttons
          Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //book mark
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPostBookMarked = !isPostBookMarked;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(
                              isPostBookMarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_add_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //like button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPostLiked = !isPostLiked;
                          meme.ups += isPostLiked ? 1 : -1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(isPostLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined),
                          ),
                        ),
                      ),
                    ),
                    // share button
                    GestureDetector(
                      onTap: () {
                        // TODO : share button
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(Icons.share),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
