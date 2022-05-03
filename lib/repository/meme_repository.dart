import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_downloader/image_downloader.dart';
import '../models/meme_model.dart';

class MemeRepository {
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

// fetch memes we got Today
  getMemes() async {
    // check if user is logged in
    if (firebaseAuth.currentUser != null) {
      var date = await getDate();
      var memesSnapshot = await FirebaseFirestore.instance
          .collection('memes')
          .doc(date)
          .collection('memes')
          .get();

      if (memesSnapshot.docs.isNotEmpty) {
        List<Meme> memesList = [];
        for (var memeSnapshot in memesSnapshot.docs) {
          var memeJson = memeSnapshot.data();
          var memeSnapshotId = memeSnapshot.id;

          if (memeJson['author'] != null &&
              memeJson['postLink'] != null &&
              memeJson['subreddit'] != null &&
              memeJson['title'] != null &&
              memeJson['url'] != null &&
              memeJson['preview'] != null &&
              memeJson['nsfw'] != null &&
              memeJson['spoiler'] != null &&
              memeJson['ups'] != nullptr) {
            Meme meme = Meme(
                id: memeSnapshotId,
                author: memeJson['author'],
                postLink: memeJson['postLink'],
                subReddit: memeJson['subreddit'],
                title: memeJson['title'],
                url: memeJson['url'],
                preview: memeJson['preview'],
                nsfw: memeJson['nsfw'],
                spoiler: memeJson['spoiler'],
                ups: memeJson['ups'],
                source: 'reddit',
                image460: '',
                length: null,
                type: '',
                videoUrl: '');
            memesList.add(meme);
          }
        }

        if (memesList.length > 2) {
          return memesList;
        } else {
          throw Exception('Not Enough Memes Found');
        }
      } else {
        throw Exception('No memes found');
      }
    } else {
      throw Exception('User not logged in try opening app again');
    }
  }

  //download a meme

  downloadMeme({required String url, required String fileName}) async {
    // Saved with this method.
    var imageId = await ImageDownloader.downloadImage(url);
    if (imageId == null) {
      throw Exception('Error Downloading Meme');
    }
  }

  // report meme
  reportMeme({required String id, required Meme meme}) async {
    // check if user is logged in
    if (1 == 1) {
      var date = await getDate();
      var reportRef = FirebaseFirestore.instance
          .collection('memes')
          .doc(date)
          .collection('reports');
      var meme = await FirebaseFirestore.instance
          .collection('memes')
          .doc(date)
          .collection('memes')
          .doc(id)
          .get();
      var memeJson = meme.data();
      if (memeJson != null) {
        reportRef.doc(id).set(memeJson);
        await FirebaseFirestore.instance
            .collection('memes')
            .doc(date)
            .collection('memes')
            .doc(id)
            .delete();
        print('removed meme');
      } else {
        throw Exception('Could Not Report Meme');
      }
    } else {
      throw Exception('No user found');
    }
  }

  getNinePosts() async {
    // check if user is logged in
    if (firebaseAuth.currentUser != null) {
      print('getting nine posts');
      var date = await getDate();
      var memesSnapshot = await FirebaseFirestore.instance
          .collection('memes')
          .doc(date)
          .collection('nineposts')
          .get();

      if (memesSnapshot.docs.isNotEmpty) {
        List<Meme> memesList = [];
        for (var memeSnapshot in memesSnapshot.docs) {
          var memeJson = memeSnapshot.data();
          var memeSnapshotId = memeSnapshot.id;

          if (memeJson['images']['image460']['url'] != null &&
              memeJson['type'] != null &&
              memeJson['upVoteCount'] != null &&
              memeJson['promoted'] == 0 &&
              memeJson['nsfw'] != null &&
              memeJson['nsfw'] == 0) {
            Meme meme = Meme(
                author: 'Trending',
                id: memeSnapshotId,
                image460: memeJson['images']['image460']['url'],
                length: null,
                nsfw: false,
                postLink: '',
                preview: [],
                source: 'nine',
                spoiler: false,
                subReddit: 'Hot',
                title: memeJson['title'],
                type: memeJson['type'],
                ups: memeJson['upVoteCount'],
                url: memeJson['images']['image460']['url'],
                videoUrl: memeJson['images']['image460sv'] != null
                    ? memeJson['images']['image460sv']['url']
                    : null);
            memesList.add(meme);
          }
        }
        if (memesList.length > 2) {
          return memesList;
        } else {
          throw Exception('Not Enough Memes Found');
        }
      } else {
        throw Exception('No memes found');
      }
    } else {
      throw Exception('User not logged in try opening app again');
    }
  }
}
