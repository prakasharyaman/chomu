import 'package:chomu/ads/widgets/small_banner_ad.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../app/controllers/firebase_controller.dart';
import '../../../models/meme_model.dart';
import '../../../services/share_service.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key, required this.meme}) : super(key: key);
  final Meme meme;
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Meme meme;
  bool watched = false;
  bool isPostLiked = false;

  bool isPostBookMarked = false;
  StoriesController storiesController = Get.find();
  @override
  void initState() {
    meme = widget.meme;
    super.initState();
    FirebaseController firebaseController = Get.find();
    firebaseController.logFirebaseEvent(eventName: 'StoryView');
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _cardKey = GlobalKey();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return VisibilityDetector(
      key: Key(meme.url),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.9) {
          if (watched != true) {
            storiesController.saveMemeAsWatched(url: meme.url);
            watched = true;
          }
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
                child: RepaintBoundary(
                  key: _cardKey,
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isPostLiked = !isPostLiked;
                        meme.ups += isPostLiked ? 1 : -1;
                      });
                    },
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
                                ? Colors.white38.withOpacity(0.3)
                                : Colors.grey.shade500.withOpacity(0.3),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        customButton: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.white38.withOpacity(0.3)
                                  : Colors.grey.shade500.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Icon(Icons.more_vert_rounded),
                            ),
                          ),
                        ),
                        openWithLongPress: true,
                        customItemsIndexes: const [4],
                        customItemsHeight: 8,
                        items: [
                          ...MenuItems.firstItems.map(
                            (item) => DropdownMenuItem<MenuItem>(
                              value: item,
                              child: MenuItems.buildItem(item),
                            ),
                          ),
                          const DropdownMenuItem<Divider>(
                              enabled: false, child: Divider()),
                          ...MenuItems.secondItems.map(
                            (item) => DropdownMenuItem<MenuItem>(
                              value: item,
                              child: MenuItems.buildItem(item),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          switch (value) {
                            case MenuItems.remove:
                              //Do something
                              storiesController.saveMemeAsWatched(
                                  url: meme.url);
                              Get.snackbar(
                                'Refresh ',
                                'We have removed this meme',
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              break;
                            case MenuItems.block:
                              // block user
                              if (meme.url != '') {
                                Get.defaultDialog(
                                    title: "Block User ${meme.author} ?",
                                    middleText:
                                        "Are You Sure You Want To Block ${meme.author} . This will block all posts from this user \n and will not show them in your feed",
                                    radius: 30,
                                    onConfirm: () {
                                      storiesController.blockUser(
                                          userName: meme.author);
                                      storiesController.getMemes();
                                      Get.back();
                                    },
                                    onCancel: () {
                                      Get.back();
                                    });
                              } else {
                                Get.snackbar('Oops',
                                    'We were not able to block the user \n  Please try again later',
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                              break;
                            case MenuItems.report:
                              storiesController.reportMeme(meme: meme);
                              storiesController.getMemes();
                              break;
                            case MenuItems.download:
                              FileDownloadService fileDownloadService =
                                  Get.find();
                              if (meme.type == 'Animated') {
                                fileDownloadService.requestDownload(
                                  url: meme.videoUrl!,
                                  name: 'Chomu Video',
                                );
                              } else {
                                fileDownloadService.requestDownload(
                                  url: meme.url,
                                  name: meme.title,
                                );
                              }

                              break;
                            case MenuItems.cancel:
                              //Do something
                              break;
                          }
                        },
                        itemHeight: 48,
                        itemPadding: const EdgeInsets.only(left: 16, right: 16),
                        dropdownWidth: 160,
                        dropdownPadding:
                            const EdgeInsets.symmetric(vertical: 6),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        dropdownElevation: 8,
                        offset: const Offset(40, -4),
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
                    Text(
                      meme.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(meme.author,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
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
                        if (!isPostBookMarked) {
                          storiesController.bookmarkMeme(meme: meme);
                        } else {
                          storiesController.removeBookmarkMeme(meme: meme);
                        }
                        setState(() {
                          isPostBookMarked = !isPostBookMarked;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white38.withOpacity(0.3)
                                : Colors.grey.shade500.withOpacity(0.3),
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
                                ? Colors.white38.withOpacity(0.3)
                                : Colors.grey.shade500.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(
                                isPostLiked
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: isPostLiked ? Colors.red : Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // share button
                    GestureDetector(
                      onTap: () {
                        Future.delayed(
                            const Duration(milliseconds: 200),
                            () => convertWidgetToImageAndShare(
                                context, _cardKey, meme.title));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.white38.withOpacity(0.3)
                                : Colors.grey.shade500.withOpacity(0.3),
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
          //ad
          // const Align(
          //   alignment: Alignment.topCenter,
          //   child: SafeArea(child: SmallBannerAd()),
          // ),
        ],
      ),
    );
  }
}

// menu item
class MenuItem {
  final String text;
  final IconData icon;
  final Color? color;
  const MenuItem({
    required this.text,
    required this.icon,
    this.color,
  });
}

class MenuItems {
  final Meme meme;
  static const List<MenuItem> firstItems = [report, block, download, remove];
  static const List<MenuItem> secondItems = [cancel];

  static const block =
      MenuItem(text: 'Block', icon: Icons.block, color: Colors.red);
  static const report = MenuItem(
      text: 'Report',
      icon: Icons.report_gmailerrorred_rounded,
      color: Colors.red);
  static const remove = MenuItem(
    text: 'Remove',
    icon: Icons.delete,
  );
  static const download = MenuItem(
    text: 'Download',
    icon: Icons.download,
  );
  static const cancel = MenuItem(
    text: 'Cancel',
    icon: Icons.cancel,
  );

  MenuItems({required this.meme});

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: item.color ?? (Get.isDarkMode ? Colors.white : Colors.black),
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: TextStyle(
            color: item.color ?? (Get.isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.remove:
        //Do something
        break;
      case MenuItems.report:
        //Do something
        break;
      case MenuItems.download:
        //Do something
        break;
      case MenuItems.cancel:
        //Do something
        break;
    }
  }
}
