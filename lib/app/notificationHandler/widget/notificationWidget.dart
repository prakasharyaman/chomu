import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chomu/repository/cloud_post_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/meme_model.dart';

import '../../../services/share_service.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key, required this.receivedNotification})
      : super(key: key);
  final ReceivedNotification receivedNotification;

  @override
  Widget build(BuildContext context) {
    GlobalKey _cardKey = GlobalKey();
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // check if connection state is done
            if (snapshot.hasData) {
              // if snapshot contains data
              if (snapshot.data != null) {
                // if snapshot data is not null
                Meme meme = snapshot.data as Meme;
                // build the post
                return RepaintBoundary(
                  key: _cardKey,
                  child: Card(
                      elevation: 10,
                      shadowColor: Colors.purpleAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                icon: const Icon(
                                  Icons.bookmark_add_outlined,
                                ),
                                onPressed: () {
                                  Get.back();
                                  Get.snackbar(
                                      'Saved', 'Post saved to your bookmarks',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.purpleAccent,
                                      borderColor: Colors.purpleAccent,
                                      icon: const Icon(
                                        Icons.bookmark,
                                        color: Colors.white,
                                      ));
                                },
                              ),
                              // close button
                              IconButton(
                                  tooltip: 'Close',
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.close_rounded)),
                            ],
                          ),
                          // title
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 8),
                            child: Text(
                              meme.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Image
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: Get.height * 0.85,
                              minHeight: Get.height * 0.4,
                            ),
                            child: Container(
                              color: Get.isDarkMode
                                  ? Colors.black38
                                  : Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image(
                                  filterQuality: FilterQuality.none,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  image: NetworkImage(meme.url),
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return SizedBox(
                                      height: Get.height * 0.4,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      )),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object object, StackTrace? stackTrace) {
                                    debugPrint(
                                        'Image threw an error \n Reporting to the developer');

                                    return SizedBox(
                                      height: Get.height * 0.4,
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
                          // upvote and share
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar('Thanks For FeedBack',
                                        'We will show more posts like this');
                                  },
                                ),
                                Text(
                                  NumberFormat.compact().format(meme.ups),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.thumb_down_alt_outlined,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                    Get.snackbar('Thanks For FeedBack',
                                        'We will show less posts like this');
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
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          } else {
            return Container(
                height: Get.height,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()));
          }
        },
        future: CloudPostRepository()
            .getPostFromCloud(docId: receivedNotification.payload!['docId']!));
  }
}
