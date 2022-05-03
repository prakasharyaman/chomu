class Meme {
  String author, postLink, subReddit, title, url, id;
  List<dynamic> preview;
  String? image460, videoUrl;
  bool nsfw, spoiler;

  int? length;
  String source;
  String? type;
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
    required this.source,
    required this.image460,
    required this.videoUrl,
    required this.length,
    required this.type,
  });
  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'] as String,
      source: "reddit",
      author: json['author'] as String,
      postLink: json['postLink'] as String,
      subReddit: json['subreddit'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      preview: json['preview'] as List<dynamic>,
      nsfw: json['nsfw'] as bool,
      spoiler: json['spoiler'] as bool,
      ups: json['ups'] as int,
      image460: '',
      length: null,
      type: '',
      videoUrl: '',
    );
  }
  static Map<String, dynamic> toJson(Meme meme) => {
        'id': meme.id,
        'author': meme.author,
        'postLink': meme.postLink,
        'subreddit': meme.subReddit,
        'title': meme.title,
        'url': meme.url,
        'preview': meme.preview,
        'nsfw': meme.nsfw,
        'spoiler': meme.spoiler,
        'ups': meme.ups,
      };
}
