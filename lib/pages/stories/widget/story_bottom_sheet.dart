import 'package:chomu/models/nine_post.dart';
import 'package:chomu/pages/stories/controller/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/download_service.dart';

class StoryBottomSheet extends StatelessWidget {
  const StoryBottomSheet({Key? key, required this.ninePost}) : super(key: key);
  final NinePost ninePost;

  @override
  Widget build(BuildContext context) {
    StoriesController storiesController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              storiesController.reportPost(ninePost: ninePost);
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
              storiesController.blockUser(userName: 'ChomuKing');
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
                url: ninePost.images.image460sv != null
                    ? ninePost.images.image460sv!.url
                    : ninePost.images.image460.url,
                name: ninePost.title,
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
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Close',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
