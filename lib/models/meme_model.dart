class Meme {
  String author, postLink, subReddit, title, url, id;
  List<dynamic> preview;
  bool nsfw, spoiler;
  int ups;
  Meme({
    required this.id,
    required this.author,
    required this.postLink,
    required this.subReddit,
    required this.title,
    required this.url,
    required this.preview,
    required this.nsfw,
    required this.spoiler,
    required this.ups,
  });
  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'] as String,
      author: json['author'] as String,
      postLink: json['postLink'] as String,
      subReddit: json['subreddit'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      preview: json['preview'] as List<String>,
      nsfw: json['nsfw'] as bool,
      spoiler: json['spoiler'] as bool,
      ups: json['ups'] as int,
    );
  }
}
