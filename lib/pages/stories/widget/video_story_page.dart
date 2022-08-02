// 🎯 Dart imports:
import 'dart:developer';
import 'dart:ui';
// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
// 🌎 Project imports:
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/services/share_service.dart';
import '../../../app/app.dart';
import '../../../models/meme_model.dart';
import '../../../services/download_service.dart';

class VideoStoryPage extends StatefulWidget {
  const VideoStoryPage(
      {Key? key,
      required this.meme,
      required this.videoPlayerController,
      required this.isLoading})
      : super(key: key);
  final Meme meme;
  final VideoPlayerController videoPlayerController;
  final bool isLoading;
  @override
  State<VideoStoryPage> createState() => _VideoStoryPageState();
}

class _VideoStoryPageState extends State<VideoStoryPage> {
  StoriesController storiesController = Get.find<StoriesController>();
  late VideoPlayerController _controller;
  late VideoPlayerController _blurVideoController;
  late Meme meme;
  bool isPostLiked = false;
  bool isPostBookMarked = false;
  late bool isMute;
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
    isMute = storiesController.volume.toDouble() > 0 ? false : true;
    _controller = widget.videoPlayerController;
    _blurVideoController = _controller;

    _controller.setLooping(true);
    _blurVideoController.setLooping(true);
    _blurVideoController.setVolume(0);
    _controller.setVolume(storiesController.volume.toDouble());
    storiesController.saveMemeAsWatched(url: meme.url);
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        //blurred background video
        _backgroundBlurredVideo(),
        // video controls
        Stack(
          fit: StackFit.expand,
          children: [
            // video player
            Align(
              alignment: Alignment.center,
              child: 1 == 1
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            // gesture detector to mute video
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: height * 0.6,
                width: width,
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      isPostLiked = !isPostLiked;
                    });
                  },
                  onTap: () {
                    isMute
                        ? _controller.setVolume(100)
                        : _controller.setVolume(0);
                    isMute
                        ? storiesController.setVolume(setVolume: 100)
                        : storiesController.setVolume(setVolume: 0);
                    setState(() {
                      isMute = !isMute;
                    });
                  },
                ),
              ),
            ), // back button and dropdown

            // title and author
            Positioned(
                bottom: 0,
                right: 50,
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(meme.author,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                          )),
                    ],
                  ),
                )),

            // floating buttons
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // //next page
                      // GestureDetector(
                      //   onTap: () {
                      //     pageController.nextPage(
                      //         duration: const Duration(milliseconds: 300),
                      //         curve: Curves.easeInOut);
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Get.isDarkMode
                      //             ? Colors.white38.withOpacity(0.3)
                      //             : Colors.grey.shade500.withOpacity(0.3),
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.only(
                      //             top: 8.0,
                      //             bottom: 8.0,
                      //             left: 15.0,
                      //             right: 15.0),
                      //         child: Icon(
                      //           Icons.arrow_upward_rounded,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // mute button
                      Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            isMute
                                ? _controller.setVolume(100)
                                : _controller.setVolume(0);
                            isMute
                                ? storiesController.setVolume(setVolume: 100)
                                : storiesController.setVolume(setVolume: 0);
                            setState(() {
                              isMute = !isMute;
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
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 15.0,
                                    right: 15.0),
                                child: Icon(
                                  isMute
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // share button
                      GestureDetector(
                        onTap: () {
                          Future.delayed(
                              const Duration(milliseconds: 200),
                              () => downloadAndSharePost(
                                  name: meme.title, url: meme.videoUrl!));
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
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Icon(
                                FontAwesomeIcons.share,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Icon(
                                isPostBookMarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_add_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //like button
                      GestureDetector(
                        onTap: () {
                          print(storiesController.volume);
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
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Icon(
                                  isPostLiked
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color:
                                      isPostLiked ? Colors.red : Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // more
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
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  color: Colors.white,
                                ),
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
                                      title: "Block User ${meme.author}",
                                      middleText:
                                          "Are You Sure You Want To Block ${meme.author} \n This will block all posts from this user \n and will not show them in your feed",
                                      radius: 30,
                                      onConfirm: () {
                                        storiesController.blockUser(
                                            userName: meme.author);
                                        Future.delayed(const Duration(
                                                milliseconds: 2100))
                                            .then(
                                                (_) => Get.offAll(const App()));
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
                          itemPadding:
                              const EdgeInsets.only(left: 16, right: 16),
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
                )),
          ],
        ),
      ],
    );
  }

  Stack _backgroundBlurredVideo() {
    return Stack(
      children: [
        1 == 1
            ? SizedBox(
                height: Get.height,
                width: Get.width,
                child: VideoPlayer(_blurVideoController),
              )
            : Container(),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
      ],
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
