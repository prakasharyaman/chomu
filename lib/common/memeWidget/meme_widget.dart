import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../app/controllers/firebase_controller.dart';
import '../../models/meme_model.dart';
import '../../pages/home/tabs/hot/controller/hot_controller.dart';
import '../../services/share_service.dart';

class MemeWidget extends StatefulWidget {
  const MemeWidget(
      {Key? key,
      required this.meme,
      required this.height,
      required this.menuFunction})
      : super(key: key);
  final Meme meme;
  final double height;
  final Function menuFunction;
  @override
  State<MemeWidget> createState() => _MemeWidgetState();
}

class _MemeWidgetState extends State<MemeWidget> {
  late Meme meme;
  late double height;
  bool isPostLiked = false;
  late Function menuFunction;
  HotController hotController = Get.find();
  bool isPostBookMarked = false;
  bool watched = false;
  @override
  void initState() {
    super.initState();
    menuFunction = widget.menuFunction;
    meme = widget.meme;
    height = widget.height;
    FirebaseController firebaseController = Get.find();
    firebaseController.logFirebaseEvent(eventName: 'MemeView');
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _cardKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: RepaintBoundary(
        key: _cardKey,
        child: VisibilityDetector(
          key: Key(meme.url),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.8) {
              if (watched == false) {
                watched = true;
                hotController.saveMemeAsWatched(url: meme.url);
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
                      if (!isPostBookMarked) {
                        hotController.bookmarkMeme(meme: meme);
                      } else {
                        hotController.removeBookmarkMeme(meme: meme);
                      }
                      setState(() {
                        isPostBookMarked = !isPostBookMarked;
                      });
                    },
                  ),
                  // menu button
                  IconButton(
                      onPressed: () {
                        menuFunction();
                      },
                      icon: const Icon(Icons.more_vert_rounded))
                ],
              ),
              // title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                child: Text(
                  meme.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Image
              Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                  minHeight: height * 0.4,
                ),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      isPostLiked = !isPostLiked;
                      meme.ups += isPostLiked ? 1 : -1;
                    });
                  },
                  child: Container(
                    color:
                        Get.isDarkMode ? Colors.black38 : Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image(
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        image: NetworkImage(meme.url),
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
                          print(
                              'Image threw an error \n Reporting to the developer');
                          hotController.reportMeme(meme: meme, hideSnack: true);

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
                ),
              ),
              // upvote and share
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
                      onPressed: () {
                        Get.snackbar('Sorry !',
                            'Comments have been diabled due to some issues',
                            snackPosition: SnackPosition.BOTTOM);
                      },
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
                                context, _cardKey, meme.title));
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
