// Dart imports:

// ignore_for_file: avoid_print

// Dart imports:
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
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
          text: 'Hey check out this *MEME* from *CHOMU*.\n\n' +
              'https://play.google.com/store/apps/details?id=android.chomu' +
              '\n' +
              title,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }).catchError((onError) {
      print(onError);
    });
  });
}
