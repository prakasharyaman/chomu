// ignore_for_file: must_be_immutable

// 🐦 Flutter imports:
import 'package:chomu/models/index.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:chomu/services/download_service.dart';
import 'package:chomu/services/share_service.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({Key? key, required this.redditPost}) : super(key: key);

  final RedditPost redditPost;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Close'))),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  //TODO: report post
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const Divider(),
              // block
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                      title: "Block User ${redditPost.author}",
                      middleText:
                          "Are You Sure You Want To Block ${redditPost.author} . This will block all posts from this user . And will not show them in your feed",
                      radius: 20,
                      onConfirm: () {
                        Get.back();

                        //TODO: block user
                      },
                      onCancel: () {
                        Get.back();
                      });

                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Block',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const Divider(),
              // Download
              GestureDetector(
                onTap: () async {
                  Get.back();

                  FileDownloadService fileDownloadService = Get.find();

                  fileDownloadService.requestDownload(
                    url: redditPost.url,
                    name: redditPost.title,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Download',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const Divider(),
              // share button
              GestureDetector(
                onTap: () {
                  downloadAndSharePost(
                      url: redditPost.url, name: redditPost.title);

                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Share',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const Divider(),
              // when appear on home , the share button is not visible
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
