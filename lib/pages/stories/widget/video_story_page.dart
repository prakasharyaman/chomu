import 'dart:ui';
import 'package:chomu/app/controllers/volume_controller.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../app/app.dart';
import '../../../app/controllers/firebase_controller.dart';
import '../../../models/meme_model.dart';
import '../../../services/download_service.dart';

class VideoStoryPage extends StatefulWidget {
  const VideoStoryPage({Key? key, required this.meme}) : super(key: key);
  final Meme meme;
  @override
  State<VideoStoryPage> createState() => _VideoStoryPageState();
}

class _VideoStoryPageState extends State<VideoStoryPage> {
  VolumeController volumeController = Get.find();
  late VideoPlayerController _controller;
  late VideoPlayerController _blurVideoController;
  late Meme meme;
  bool watched = false;
  bool isPostLiked = false;
  bool videoLoaded = false;
  bool blurVideoLoaded = false;
  bool isPostBookMarked = false;
  late bool isMute;
  late double volume;
  StoriesController storiesController = Get.find();
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
    volume = volumeController.volume;
    FirebaseController firebaseController = Get.find();
    firebaseController.logFirebaseEvent(eventName: 'videoview');

    _controller = VideoPlayerController.network(
      meme.videoUrl ?? '',
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          videoLoaded = true;
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      });
    _blurVideoController = _controller;
    // set looping to true
    _blurVideoController.setLooping(true);

    // set volume to zero
    _blurVideoController.setVolume(0);
    volume > 0 ? isMute = false : isMute = true;
    _controller.setVolume(volume);
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    GlobalKey _cardKey = GlobalKey();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        //blurred background video
        _backgroundBlurredVideo(),
        // video controls
        VisibilityDetector(
          key: Key(meme.url),
          onVisibilityChanged: (VisibilityInfo info) {
            if (info.visibleFraction > 0.9) {
              if (watched != true) {
                debugPrint('watched video');

                storiesController.saveMemeAsWatched(url: meme.url);
                watched = true;
              }
            }
          },
          child: Stack(
            children: [
              // video player
              Align(
                alignment: Alignment.center,
                child: videoLoaded
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
                          ? volumeController.setVolume(value: 100)
                          : volumeController.setVolume(value: 0);
                      setState(() {
                        isMute = !isMute;
                      });
                    },
                  ),
                ),
              ), // back button and dropdown
              // back button
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
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 15.0,
                                    right: 15.0),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                ),
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
                                              .then((_) =>
                                                  Get.offAll(const App()));
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
                  )), // title
              // title and author
              Positioned(
                  bottom: 10,
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
              // mute button
              Positioned(
                bottom: 100,
                left: 10,
                child: Visibility(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          isMute
                              ? _controller.setVolume(100)
                              : _controller.setVolume(0);
                          isMute
                              ? volumeController.setVolume(value: 100)
                              : volumeController.setVolume(value: 0);
                          setState(() {
                            isMute = !isMute;
                          });
                        },
                        child: const Icon(
                          Icons.volume_off_rounded,
                          color: Colors.white,
                        )),
                  ),
                  visible: isMute,
                ),
              ),

              // floating buttons
              Positioned(
                  bottom: 30,
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
                                    color: isPostLiked
                                        ? Colors.red
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        // share button
                        // GestureDetector(
                        //   onTap: () {

                        //     Future.delayed(
                        //         const Duration(milliseconds: 200),
                        //         () => convertWidgetToImageAndShare(
                        //             context, _cardKey, meme.title));
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
                        //             top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                        //         child: Icon(Icons.share),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Stack _backgroundBlurredVideo() {
    return Stack(
      children: [
        videoLoaded
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
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
