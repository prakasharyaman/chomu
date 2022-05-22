import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class FileDownloadService extends GetxController
    with GetSingleTickerProviderStateMixin {
  void requestDownload({required String url, required String name}) async {
    // ignore: unused_local_variable
    final file = await FileDownloader.downloadFile(
        url: url,
        name: name,
        onProgress: (name, progress) {
          debugPrint(progress.toDouble().toString());
          if (progress.toDouble() == 0.0) {
            Get.snackbar('Downloading', 'The post is being downloaded',
                backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
                colorText: Get.isDarkMode ? Colors.white : Colors.purple,
                icon: Icon(Icons.download_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.purple),
                messageText: LinearProgressIndicator(
                  color: Get.isDarkMode ? Colors.white : Colors.purple,
                ));
          }
        },
        onDownloadCompleted: (path) {
          Get.snackbar('Download Complete', 'The download has been completed',
              backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
              colorText: Get.isDarkMode ? Colors.white : Colors.purple,
              icon: Icon(Icons.done,
                  color: Get.isDarkMode ? Colors.white : Colors.purple),
              messageText: GestureDetector(
                onTap: () {
                  // opens the file we clicked on
                  try {
                    OpenFile.open(path);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'Click to open the file',
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      'Open',
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ));
        },
        onDownloadError: (error) {
          Get.snackbar(
            'Error Downloading ',
            error.toString(),
            backgroundColor: Get.isDarkMode ? Colors.black54 : Colors.white,
            colorText: Get.isDarkMode ? Colors.white : Colors.purple,
          );
        });
  }
}
