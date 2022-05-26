// Dart imports:

// ignore_for_file: avoid_print

// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:path_provider/path_provider.dart';

// Flutter imports:

// Project imports:

void convertWidgetToImageAndShare(
    BuildContext context, containerKey, title) async {
  List<String> imagePaths = [];
  final RenderBox box = context.findRenderObject() as RenderBox;
  return Future.delayed(const Duration(milliseconds: 20), () async {
    RenderRepaintBoundary? boundary = containerKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    final pth = await getApplicationDocumentsDirectory();
    var directory = pth.path;

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    File imgFile = File('$directory/screenshot.png');
    imagePaths.add(imgFile.path);
    imgFile.writeAsBytes(pngBytes).then((value) async {
      await Share.shareFiles(imagePaths,
          subject: 'CHOMU',
          text:
              'Hey check out this *POST* from *CHOMU*.\n\n https://bit.ly/chomuApp \n' +
                  title,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }).catchError((onError) {
      print(onError);
    });
  });
}

void downloadAndSharePost({required String url, required String name}) async {
  try {
    final file = await FileDownloader.downloadFile(
        url: url,
        name: name,
        onProgress: (name, progress) {
          debugPrint(progress.toDouble().toString());
          if (progress.toDouble() == 0.0) {
            Get.snackbar('Preparing for Sharing. Please wait.', 'Hold On',
                backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
                colorText: Get.isDarkMode ? Colors.white : Colors.purple,
                icon: Icon(FontAwesomeIcons.share,
                    color: Get.isDarkMode ? Colors.white : Colors.purple),
                messageText: LinearProgressIndicator(
                  color: Get.isDarkMode ? Colors.white : Colors.purple,
                ));
          }
        },
        onDownloadCompleted: (path) async {
          List<String> imagePaths = [];
          imagePaths.add(path);
          await Share.shareFiles(
            imagePaths,
            subject: name,
            text:
                'Check this out: Download *CHOMU*.\n https://bit.ly/chomuApp \n\n' +
                    name,
          );
          File tobeDeleted = File(path);
          await tobeDeleted.delete();
        },
        onDownloadError: (error) {
          throw Exception('Error While Sharing ');
        });
  } catch (e) {
    Get.snackbar(
      'Uh oh!',
      e.toString(),
      backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
      colorText: Get.isDarkMode ? Colors.white : Colors.purple,
    );
  }
}
