import 'package:chomu/models/meme_model.dart';
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/share_service.dart';

class BookMarkMemePage extends StatefulWidget {
  const BookMarkMemePage({Key? key, required this.meme}) : super(key: key);
  final Meme meme;
  @override
  State<BookMarkMemePage> createState() => _BookMarkMemePageState();
}

class _BookMarkMemePageState extends State<BookMarkMemePage> {
  late Meme meme;
  bool watched = false;
  bool isPostLiked = false;

  bool isPostBookMarked = true;
  HotController hotController = Get.find();
  @override
  void initState() {
    super.initState();
    meme = widget.meme;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _cardKey = GlobalKey();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
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
                                ? Colors.white12
                                : Colors.grey.shade300,
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
                                  ? Colors.white12
                                  : Colors.grey.shade300,
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
                              // hotController.downloadMemeUrl(
                              //     url: meme.url, fileName: meme.title);
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
                    Text(meme.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(meme.author,
                        style: const TextStyle(
                          fontSize: 10,
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
                          hotController.bookmarkMeme(meme: meme);
                        } else {
                          hotController.removeBookmarkMeme(meme: meme);
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
                                ? Colors.white12
                                : Colors.grey.shade300,
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
                                ? Colors.white12
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                            child: Icon(isPostLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined),
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
                                ? Colors.white12
                                : Colors.grey.shade300,
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
        ],
      ),
    );
  }
}

// menu item
class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  final Meme meme;
  static const List<MenuItem> firstItems = [report, download, remove];
  static const List<MenuItem> secondItems = [cancel];

  static const report =
      MenuItem(text: 'Report', icon: Icons.report_gmailerrorred_rounded);
  static const remove = MenuItem(text: 'Remove', icon: Icons.delete);
  static const download = MenuItem(text: 'Download', icon: Icons.download);
  static const cancel = MenuItem(text: 'Cancel', icon: Icons.cancel);

  MenuItems({required this.meme});

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
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
