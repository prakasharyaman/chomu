import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/app/controllers/volume_controller.dart';
import 'package:chomu/common/memeWidget/meme_widget.dart';
import 'package:chomu/common/menu/dropdown_menu.dart';
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../app/controllers/firebase_controller.dart';
import '../../models/meme_model.dart';

// class VideoList extends StatefulWidget {
//   const VideoList({Key? key}) : super(key: key);

//   @override
//   State<VideoList> createState() => _VideoListState();
// }

// class _VideoListState extends State<VideoList> {
//   HotController hotController = Get.find();
//   bool showReport = false;
//   Meme? menuMeme;
//   @override
//   Widget build(BuildContext context) {
//     var memes = hotController.memes;
//     return Stack(
//       fit: StackFit.expand,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               gradient: Get.isDarkMode
//                   ? const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomLeft,
//                       colors: [
//                         Color.fromARGB(255, 9, 9, 9),
//                         Color.fromARGB(255, 8, 8, 8),
//                       ],
//                     )
//                   : const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomLeft,
//                       colors: [
//                         Color.fromARGB(255, 245, 246, 248),
//                         Color.fromARGB(255, 244, 247, 250),
//                       ],
//                     )),
//           margin: const EdgeInsets.only(left: 1, right: 1),
//           child: NestedScrollView(
//             floatHeaderSlivers: true,
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   automaticallyImplyLeading: false,
//                   centerTitle: false,
//                   floating: true,
//                   title: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // icon
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showReport = !showReport;
//                           });
//                         },
//                         child: const CircleAvatar(
//                           backgroundImage: CachedNetworkImageProvider(
//                               'https://i.gifer.com/origin/b8/b842107e63c67d5674d17e0f576274fa_w200.gif'),
//                           radius: 15,
//                         ),
//                       ),
//                       const SizedBox(width: 5),
//                       //app Title
//                       Text(
//                         "CHOMU",
//                         style: TextStyle(
//                             color: Get.isDarkMode
//                                 ? Colors.white
//                                 : Colors.deepPurple,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       //spacer
//                       const Spacer(),
//                       // icon search
//                       IconButton(
//                           onPressed: () {
//                             // controller.getMemes();
//                           },
//                           iconSize: 25,
//                           icon: Icon(
//                             Icons.replay_rounded,
//                             color: Get.isDarkMode
//                                 ? Colors.white
//                                 : Colors.deepPurple,
//                           )),
//                     ],
//                   ),
//                   backgroundColor: Colors.transparent,
//                 ),
//               ];
//             },
//             body: RefreshIndicator(
//               onRefresh: () async {
//                 print('ji');
//               },
//               child: Stack(
//                 children: [
//                   InViewNotifierList(
//                     physics: const BouncingScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     initialInViewIds: ['0'],
//                     isInViewPortCondition: (double deltaTop, double deltaBottom,
//                         double viewPortDimension) {
//                       return deltaTop < (0.5 * viewPortDimension) &&
//                           deltaBottom > (0.5 * viewPortDimension);
//                     },
//                     itemCount: memes.length,
//                     builder: (BuildContext context, int index) {
//                       if (memes[index].type == 'Animated') {
//                         return SizedBox(
//                           width: double.infinity,
//                           child: LayoutBuilder(
//                             builder: (BuildContext context,
//                                 BoxConstraints constraints) {
//                               return InViewNotifierWidget(
//                                 id: '$index',
//                                 builder: (BuildContext context, bool isInView,
//                                     Widget? child) {
//                                   return VideoPostWidget(
//                                     play: isInView,
//                                     url: memes[index].videoUrl ?? '',
//                                     post: memes[index],
//                                     height: Get.height,
//                                     menuFunction: () {
//                                       setState(() {
//                                         menuMeme = memes[index];
//                                         showReport = !showReport;
//                                       });
//                                     },
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         );
//                       }
//                       return MemeWidget(
//                         height: Get.height,
//                         meme: memes[index],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.center,
//           child: Container(
//             height: 1.0,
//             color: Colors.redAccent,
//           ),
//         ),
//         AnimatedPositioned(
//             top: showReport == false
//                 ? MediaQuery.of(context).size.height * 1.5
//                 : 150,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: DropDownMenu(
//                 onClose: () {
//                   setState(() {
//                     showReport = !showReport;
//                   });
//                 },
//                 meme: menuMeme,
//               ),
//             ),
//             duration: Duration(milliseconds: 400)),
//       ],
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: VideoList(),
//     );
//   }
// }

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
  late Future<void> _initializeVideoPlayerFuture;
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
          // if (info.visibleFraction > 0.8) {
          //   if (watched == false) {
          //     watched = true;
          //     hotController.saveMemeAsWatched(url: meme.url);
          //   }
          // }
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
                                  isMute = !isMute;
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
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Get.snackbar('Sorry !', 'You cannot share videos');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
