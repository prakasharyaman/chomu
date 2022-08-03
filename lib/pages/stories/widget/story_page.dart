// 🐦 Flutter imports:
import 'package:chomu/pages/stories/widget/story_bottom_sheet.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

// 🌎 Project imports:
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import '../../../app/controllers/firebase_controller.dart';

import '../../../models/nine_post.dart';
import '../../../services/share_service.dart';

class StoryPage extends StatefulWidget {
  const StoryPage(
      {Key? key, required this.ninePost, required this.pageController})
      : super(key: key);
  final NinePost ninePost;
  final PageController pageController;
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late NinePost ninePost;
  bool watched = false;
  bool isPostLiked = false;

  late PageController pageController;
  bool isPostBookMarked = false;
  StoriesController storiesController = Get.find();
  @override
  void initState() {
    pageController = widget.pageController;
    ninePost = widget.ninePost;
    FirebaseController firebaseController = Get.find();
    firebaseController.logFirebaseEvent(eventName: 'StoryView');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _cardKey = GlobalKey();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return VisibilityDetector(
      key: Key(ninePost.images.image460.url.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.9) {
          if (watched != true) {
            storiesController.savePostAsWatched(
                url: ninePost.images.image460.url.toString());
            watched = true;
          }
        }
      },
      child: Stack(
        children: [
          // Image
          Align(
            child: Container(
              color: Colors.black,
              height: height,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: RepaintBoundary(
                  key: _cardKey,
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isPostLiked = !isPostLiked;
                      });
                    },
                    child: Image(
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      image:
                          NetworkImage(ninePost.images.image460.url.toString()),
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
                        return SizedBox(
                          height: height * 0.3,
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
              ),
            ),
          ),

          // // title and author
          Positioned(
              bottom: 10,
              right: 50,
              left: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ninePost.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(ninePost.tags[0].key.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        )),
                  ],
                ),
              )),
          // floating buttons
          Positioned(
            top: Get.height * 0.7,
            right: 5,
            bottom: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //like
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isPostLiked = !isPostLiked;
                          });
                        },
                        icon: Icon(
                          isPostLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: isPostLiked ? Colors.red : Colors.white,
                        )),
                    //share
                    IconButton(
                        onPressed: () {
                          Future.delayed(
                              const Duration(milliseconds: 200),
                              () => downloadAndSharePost(
                                  name: ninePost.title,
                                  url: ninePost.images.image460sv!.url));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.shareNodes,
                          color: Colors.white,
                        )),
                    //more options
                    IconButton(
                        onPressed: () {
                          //show more options
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return StoryBottomSheet(
                                  ninePost: ninePost,
                                );
                              },
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                  maxHeight: Get.height * 0.4,
                                  maxWidth: Get.width));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.ellipsis,
                          color: Colors.white,
                        )),
                  ]),
            ),
          ),
          //back button
          Positioned(
              child: SafeArea(
                child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.angleLeft,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
              ),
              top: 5,
              left: 5),
        ],
      ),
    );
  }
}
