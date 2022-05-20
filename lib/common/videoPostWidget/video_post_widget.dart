import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chomu/app/controllers/volume_controller.dart';
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/controllers/firebase_controller.dart';
import '../../models/meme_model.dart';
import '../../pages/stories/stories_player.dart';

class VideoPostWidget extends StatefulWidget {
  const VideoPostWidget(
      {Key? key,
      required this.url,
      required this.play,
      required this.post,
      required this.height,
      required this.menuFunction})
      : super(key: key);
  final String url;
  final bool play;
  final Function menuFunction;
  final double height;
  final Meme post;
  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget> {
  late VideoPlayerController _controller;
  // late Future<void> _initializeVideoPlayerFuture;
  VolumeController volumeController = Get.find();
  late Meme meme;
  late double height;
  late double volume;
  bool isPostLiked = false;
  HotController hotController = Get.find();
  bool isPostBookMarked = false;
  bool watched = false;
  late Function menuFunction;
  late bool isMute;
  bool videoLoaded = false;
  static const colorizeColors = [
    Colors.white,
    Colors.white54,
    Colors.white24,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  );
  @override
  void initState() {
    super.initState();
    meme = widget.post;
    height = widget.height;
    menuFunction = widget.menuFunction;
    volume = volumeController.volume;
    volume > 0 ? isMute = false : isMute = true;
    FirebaseController firebaseController = Get.find();
    firebaseController.logFirebaseEvent(eventName: 'videopostview');
    _controller = VideoPlayerController.network(widget.url);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        videoLoaded = true;
      });
    });
    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
    _controller.setVolume(volume);
    _controller.setLooping(true);
  }

  @override
  void didUpdateWidget(VideoPostWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              Container(
                constraints: BoxConstraints(
                    maxHeight: height * 0.4,
                    maxWidth: double.infinity,
                    minHeight: height * 0.4),
                child: videoLoaded
                    ? Stack(
                        children: [
                          // video player
                          Align(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          // mute button
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Visibility(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      isMute
                                          ? _controller.setVolume(100)
                                          : _controller.setVolume(0);
                                      isMute
                                          ? volumeController.setVolume(
                                              value: 100)
                                          : volumeController.setVolume(
                                              value: 0);
                                      setState(() {
                                        isMute = !isMute;
                                      });
                                    },
                                    child:
                                        const Icon(Icons.volume_off_rounded)),
                              ),
                              visible: isMute,
                            ),
                          ),

                          // gesture detector to mute video
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: height * 0.4,
                              width: Get.width,
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
                              ),
                            ),
                          ), // back button and dropdown
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
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
                    _storyPlayerButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _storyPlayerButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              width: 1,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.purpleAccent,
                Colors.purple,
              ],
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.purpleAccent.withOpacity(0.3),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Play Stories >',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            onTap: () {
              debugPrint("Going to Stories");
              _controller.setVolume(0);
              Get.to(const StoryPlayer());
            },
          ),
        ),
      ),
    );
  }
}
