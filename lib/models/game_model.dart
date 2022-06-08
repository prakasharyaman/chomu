class Game {
  final String url;
  final String name;
  final String description;
  final String imageUrl;
  final String id;
  final DateTime? lastPlayed;

  Game(this.url, this.name, this.description, this.imageUrl, this.id,
      this.lastPlayed);
}
