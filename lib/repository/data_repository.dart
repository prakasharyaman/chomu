import 'package:chomu/models/index.dart';
import 'package:chomu/models/nine_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  FirebaseFirestore database = FirebaseFirestore.instance;
  // get redditPosts
  Future<List<RedditPost>> getRedditPosts() async {
    List<RedditPost> redditPosts = [];
    await database
        .collection('redditPosts')
        .doc(getDate())
        .collection('redditPosts')
        .get()
        .then((event) {
      for (var doc in event.docs) {
        var redditPost = RedditPost.fromJson(doc.data());
        redditPosts.add(redditPost);
      }
    });
    return redditPosts;
  }

  //get nine posts
  Future<List<NinePost>> getNinePosts() async {
    List<NinePost> ninePosts = [];
    await database
        .collection('ninePosts')
        .doc(getDate())
        .collection('ninePosts')
        .get()
        .then((event) {
      for (var doc in event.docs) {
        var ninePost = NinePost.fromJson(doc.data());
        ninePosts.add(ninePost);
      }
    });
    return ninePosts;
  }

// get Date in format of server
  String getDate() {
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
}
