import 'package:cached_network_image/cached_network_image.dart';
import 'package:chomu/repository/meme_repository.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../models/meme_model.dart';
import '../../pages/home/tabs/hot/controller/hot_controller.dart';
import '../../pages/stories/widget/story_page.dart';
import '../../services/share_service.dart';

class MemeWidget extends StatefulWidget {
  const MemeWidget({Key? key, required this.meme, required this.height})
      : super(key: key);
  final Meme meme;
  final double height;
  @override
  State<MemeWidget> createState() => _MemeWidgetState();
}

class _MemeWidgetState extends State<MemeWidget> {
  late Meme meme;
  late double height;
  bool isPostLiked = false;
  HotController hotController = Get.find();
  bool isPostBookMarked = false;
  bool watched = false;
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
    height = widget.height;
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
            if (info.visibleFraction > 0.9) {
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
                      setState(() {
                        isPostBookMarked = !isPostBookMarked;
                      });
                      hotController.bookmarkMeme(meme: meme);
                    },
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: const Padding(
                        padding: EdgeInsets.only(right: 8.0, left: 5.0),
                        child: Icon(Icons.more_vert_rounded),
                      ),
                      openWithLongPress: true,
                      customItemsIndexes: const [3],
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
                            hotController.saveMemeAsWatched(url: meme.url);
                            Get.snackbar(
                              'Refresh ',
                              'We have removed this meme',
                              snackPosition: SnackPosition.BOTTOM,
                            );

                            break;
                          case MenuItems.report:
                            hotController.reportMeme(meme: meme);
                            break;
                          case MenuItems.download:
                            hotController.downloadMemeUrl(
                                url: meme.url, fileName: meme.title);
                            break;
                          case MenuItems.cancel:
                            //Do something
                            break;
                        }
                      },
                      itemHeight: 48,
                      itemPadding: const EdgeInsets.only(left: 16, right: 16),
                      dropdownWidth: 160,
                      dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      dropdownElevation: 8,
                      offset: const Offset(40, -4),
                    ),
                  ),
                ],
              ),
              // title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                child: Text(
                  meme.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Image
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    isPostLiked = !isPostLiked;
                    meme.ups += isPostLiked ? 1 : -1;
                  });
                },
                child: Container(
                  color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.none,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      imageUrl: meme.url,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
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
