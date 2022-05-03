import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}

class FileDownloadService {
  Future<void> requestDownload(
      {required String url, required String name}) async {
    final dir = await getExternalStorageDirectory();
//From path_provider package
    if (dir != null) {
      var _localPath = dir.path + 'chomu';
      final savedDir = Directory(_localPath);

      await savedDir.create(recursive: true).then(
        (value) async {
          String? _taskid = await FlutterDownloader.enqueue(
              url: url,
              fileName: name,
              savedDir: _localPath,
              showNotification: true,
              openFileFromNotification: true,
              saveInPublicStorage: true);
        },
      );
    }
  }
}
