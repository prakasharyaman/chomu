import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/meme_model.dart';

class CloudPostRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime dateTime = DateTime.now();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// get Date in format of server
  getDate() {
    var date = '';
    var month = '';
    var year = '';
    var intdate = DateTime.now().day;
    var intmonth = DateTime.now().month;
    var intyear = DateTime.now().year;
    if (intdate < 10) {
      date = '0' + intdate.toString();
    } else {
      date = intdate.toString();
    }
    if (intmonth < 10) {
      month = '0' + intmonth.toString();
    } else {
      month = intmonth.toString();
    }
    if (intyear < 10) {
      year = '0' + intyear.toString();
    } else {
      year = intyear.toString();
    }
    return month + '_' + date + '_' + year;
  }

  Future<dynamic> getPostFromCloud({required String docId}) async {
    try {
      // check if user is logged in
      if (firebaseAuth.currentUser != null) {
        var date = await getDate();
        var postSnapshot = await FirebaseFirestore.instance
            .collection('memes')
            .doc(date)
            .collection('memes')
            .doc(docId)
            .get();
        Meme? meme;
        if (postSnapshot.exists) {
          var postJson = postSnapshot.data();
          var memeSnapshotId = postSnapshot.id;

          if (postJson!['author'] != null &&
              postJson['postLink'] != null &&
              postJson['subreddit'] != null &&
              postJson['title'] != null &&
              postJson['url'] != null &&
              postJson['preview'] != null &&
              postJson['nsfw'] != null &&
              postJson['spoiler'] != null &&
              postJson['ups'] != nullptr) {
            meme = Meme(
                id: memeSnapshotId,
                author: postJson['author'],
                postLink: postJson['postLink'],
                subReddit: postJson['subreddit'],
                title: postJson['title'],
                url: postJson['url'],
                preview: postJson['preview'],
                nsfw: postJson['nsfw'],
                spoiler: postJson['spoiler'],
                ups: postJson['ups'],
                source: 'reddit',
                image460: '',
                length: null,
                type: '',
                videoUrl: '');
          }
          return meme;
        } else {
          throw Exception('No Notification found');
        }
      } else {
        throw Exception('User not logged in , try opening app again');
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Oops', e.toString());
      return null;
    }
  }
}
