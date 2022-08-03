import 'package:flutter/foundation.dart';

@immutable
class RedditPost {
  const RedditPost({
    required this.subreddit,
    required this.title,
    required this.url,
    required this.nsfw,
    required this.spoiler,
    required this.author,
    required this.ups,
  });

  final String subreddit;
  final String title;
  final String url;
  final bool nsfw;
  final bool spoiler;
  final String author;
  final int ups;

  factory RedditPost.fromJson(Map<String, dynamic> json) => RedditPost(
      subreddit: json['subreddit'].toString(),
      title: json['title'].toString(),
      url: json['url'].toString(),
      nsfw: json['nsfw'] as bool,
      spoiler: json['spoiler'] as bool,
      author: json['author'].toString(),
      ups: json['ups'] as int);

  Map<String, dynamic> toJson() => {
        'subreddit': subreddit,
        'title': title,
        'url': url,
        'nsfw': nsfw,
        'spoiler': spoiler,
        'author': author,
        'ups': ups
      };

  RedditPost clone() => RedditPost(
      subreddit: subreddit,
      title: title,
      url: url,
      nsfw: nsfw,
      spoiler: spoiler,
      author: author,
      ups: ups);

  RedditPost copyWith(
          {String? subreddit,
          String? title,
          String? url,
          bool? nsfw,
          bool? spoiler,
          String? author,
          int? ups}) =>
      RedditPost(
        subreddit: subreddit ?? this.subreddit,
        title: title ?? this.title,
        url: url ?? this.url,
        nsfw: nsfw ?? this.nsfw,
        spoiler: spoiler ?? this.spoiler,
        author: author ?? this.author,
        ups: ups ?? this.ups,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedditPost &&
          subreddit == other.subreddit &&
          title == other.title &&
          url == other.url &&
          nsfw == other.nsfw &&
          spoiler == other.spoiler &&
          author == other.author &&
          ups == other.ups;

  @override
  int get hashCode =>
      subreddit.hashCode ^
      title.hashCode ^
      url.hashCode ^
      nsfw.hashCode ^
      spoiler.hashCode ^
      author.hashCode ^
      ups.hashCode;
}
