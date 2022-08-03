// 🎯 Dart imports:
import 'dart:ui';
// 🐦 Flutter imports:
import 'package:chomu/models/nine_post.dart';
import 'package:chomu/pages/stories/widget/story_bottom_sheet.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
// 🌎 Project imports:
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:chomu/services/share_service.dart';

class VideoStoryPage extends StatefulWidget {
  const VideoStoryPage({
    Key? key,
    required this.ninePost,
    required this.videoPlayerController,
  }) : super(key: key);
  final NinePost ninePost;
  final VideoPlayerController videoPlayerController;

  @override
  State<VideoStoryPage> createState() => _VideoStoryPageState();
}

class _VideoStoryPageState extends State<VideoStoryPage> {
  StoriesController storiesController = Get.find<StoriesController>();
  late VideoPlayerController _controller;
  late VideoPlayerController _blurVideoController;
  late NinePost ninePost;
  bool isPostLiked = false;
  bool isPostBookMarked = false;
  late bool isMute;
  @override
  void initState() {
    super.initState();
    ninePost = widget.ninePost;
    isMute = storiesController.volume.toDouble() > 0 ? false : true;
    _controller = widget.videoPlayerController;
    _blurVideoController = widget.videoPlayerController;
    storiesController.savePostAsWatched(url: ninePost.images.image460.url);
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          //blurred background video
          _backgroundBlurredVideo(),
          // video controls
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

          // title and tag
          Positioned(
              bottom: 5,
              right: 50,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ninePost.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('#' + ninePost.tags[0].key.toString().toLowerCase(),
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                        )),
                  ],
                ),
              )),

          // floating buttons
          Positioned(
            top: Get.height * 0.6,
            right: 5,
            bottom: 5,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //mute button
                    IconButton(
                        onPressed: () {
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
                        icon: Icon(
                          isMute
                              ? FontAwesomeIcons.volumeXmark
                              : FontAwesomeIcons.volumeHigh,
                          color: Colors.white,
                        )),
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
              height: Get.height,
              width: Get.width,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}
