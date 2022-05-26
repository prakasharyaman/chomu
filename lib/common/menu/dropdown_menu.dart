// ignore_for_file: must_be_immutable

import 'package:chomu/pages/home/tabs/hot/controller/hot_controller.dart';
import 'package:chomu/services/download_service.dart';
import 'package:chomu/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/meme_model.dart';

class DropDownMenu extends StatelessWidget {
  DropDownMenu({Key? key, required this.onClose, required this.meme})
      : super(key: key);
  final Function onClose;
  final Meme? meme;
  HotController hotController = Get.find();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  height: constraint.maxHeight * 0.7,
                  width: constraint.maxWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 3,
                          width: 100,
                          color: const Color(0xff9D9D9D),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            onClose();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                borderRadius: BorderRadius.circular(20)),
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Close",
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: constraint.maxHeight,
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    // report
                                    GestureDetector(
                                      onTap: () {
                                        if (meme != null) {
                                          hotController.reportMeme(meme: meme!);
                                        } else {
                                          Get.snackbar('Oops',
                                              'We were not able to report the post \n  Please try again later',
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        }
                                        onClose();
                                        hotController.getMemes();
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
                                        if (meme != null) {
                                          Get.defaultDialog(
                                              title:
                                                  "Block User ${meme!.author}",
                                              middleText:
                                                  "Are You Sure You Want To Block ${meme!.author} . This will block all posts from this user . And will not show them in your feed",
                                              radius: 20,
                                              onConfirm: () {
                                                Get.back();
                                                onClose();
                                                hotController.blockUser(
                                                    userName: meme!.author);
                                                hotController.getMemes();
                                              },
                                              onCancel: () {
                                                Get.back();
                                              });
                                        } else {
                                          Get.snackbar('Oops',
                                              'We were not able to block the user \n  Please try again later',
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        }
                                        onClose();
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
                                        if (meme != null) {
                                          FileDownloadService
                                              fileDownloadService = Get.find();
                                          if (meme!.type == 'Animated') {
                                            fileDownloadService.requestDownload(
                                              url: meme!.videoUrl!,
                                              name: 'Chomu Video',
                                            );
                                          } else {
                                            fileDownloadService.requestDownload(
                                              url: meme!.url,
                                              name: meme!.title,
                                            );
                                          }
                                        } else {
                                          Get.snackbar('Oops',
                                              'We were not able to download the post \n  Please try again later',
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        }
                                        onClose();
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
                                        if (meme != null) {
                                          if (meme!.type != null) {
                                            if (meme!.type == 'Animated') {
                                              downloadAndSharePost(
                                                  url: meme!.videoUrl!,
                                                  name: meme!.title);
                                            } else {
                                              downloadAndSharePost(
                                                  url: meme!.url,
                                                  name: meme!.title);
                                            }
                                          } else {
                                            downloadAndSharePost(
                                                url: meme!.url,
                                                name: meme!.title);
                                          }
                                        } else {
                                          Get.snackbar('Oops !',
                                              'Cannot share this post');
                                        }
                                        onClose();
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
