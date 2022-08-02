import 'package:chomu/models/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../services/share_service.dart';

class RedditWidget extends StatefulWidget {
  const RedditWidget(
      {Key? key, required this.redditPost, required this.showMenu})
      : super(key: key);
  final RedditPost redditPost;
  final Function showMenu;

  @override
  State<RedditWidget> createState() => _RedditWidgetState();
}

class _RedditWidgetState extends State<RedditWidget> {
  final _cardKey = GlobalKey();
  late RedditPost redditPost;
  bool isPostLiked = false;
  late Function showMenu;
  bool isPostBookMarked = false;
  bool watched = false;
  @override
  void initState() {
    super.initState();
    showMenu = widget.showMenu;
    redditPost = widget.redditPost;
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: RepaintBoundary(
        key: _cardKey,
        child: VisibilityDetector(
          key: Key(redditPost.url),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.8) {
              if (watched == false) {
                watched = true;
                // TODO: save as watched
              }
            }
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
                      redditPost.author,
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
                      if (!isPostBookMarked) {
                      } else {}
                      setState(() {
                        isPostBookMarked = !isPostBookMarked;
                      });
                    },
                  ),
                  // menu button
                  IconButton(
                      onPressed: () {
                        showMenu();
                      },
                      icon: const Icon(Icons.more_vert_rounded))
                ],
              ),
              // title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                child: Text(
                  redditPost.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Image
              Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                  minHeight: height * 0.4,
                  maxWidth: width,
                  minWidth: width,
                ),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      isPostLiked = !isPostLiked;
                    });
                  },
                  child: Image(
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.contain,
                    image: NetworkImage(redditPost.url),
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        height: height * 0.4,
                        child: Center(
                            child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        )),
                      );
                    },
                    errorBuilder: (BuildContext context, Object object,
                        StackTrace? stackTrace) {
                      debugPrint(
                          'Image threw an error \n Reporting to the developer');
//TODO : image threw an error
                      return SizedBox(
                        height: height * 0.4,
                        width: double.infinity,
                        child: const Center(
                          child: Icon(
                            Icons.error,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // upvote and share
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                          isPostLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: isPostLiked ? Colors.red : Colors.grey),
                      onPressed: () {
                        setState(() {
                          isPostLiked = !isPostLiked;
                        });
                      },
                    ),
                    Text(
                      NumberFormat.compact().format(redditPost.ups),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 10),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Future.delayed(
                            const Duration(milliseconds: 200),
                            () => convertWidgetToImageAndShare(
                                context, _cardKey, redditPost.title));
                      },
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
