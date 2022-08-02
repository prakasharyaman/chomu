import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'index.dart';

@immutable
class NinePost {
  const NinePost({
    required this.id,
    required this.title,
    required this.type,
    required this.nsfw,
    required this.creationTs,
    required this.images,
    required this.tags,
  });

  final String id;
  final String title;
  final String type;
  final int nsfw;
  final int creationTs;
  final Images images;
  final List<Tag> tags;

  factory NinePost.fromJson(Map<String, dynamic> json) => NinePost(
      id: json['id'].toString(),
      title: json['title'].toString(),
      type: json['type'].toString(),
      nsfw: json['nsfw'] as int,
      creationTs: json['creationTs'] as int,
      images: Images.fromJson(json['images'] as Map<String, dynamic>),
      tags: (json['tags'] as List? ?? [])
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'nsfw': nsfw,
        'creationTs': creationTs,
        'images': images.toJson(),
        'tags': tags.map((e) => e.toJson()).toList()
      };

  NinePost clone() => NinePost(
      id: id,
      title: title,
      type: type,
      nsfw: nsfw,
      creationTs: creationTs,
      images: images.clone(),
      tags: tags.map((e) => e.clone()).toList());

  NinePost copyWith(
          {String? id,
          String? title,
          String? type,
          int? nsfw,
          int? creationTs,
          Images? images,
          List<Tag>? tags}) =>
      NinePost(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        nsfw: nsfw ?? this.nsfw,
        creationTs: creationTs ?? this.creationTs,
        images: images ?? this.images,
        tags: tags ?? this.tags,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NinePost &&
          id == other.id &&
          title == other.title &&
          type == other.type &&
          nsfw == other.nsfw &&
          creationTs == other.creationTs &&
          images == other.images &&
          tags == other.tags;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      type.hashCode ^
      nsfw.hashCode ^
      creationTs.hashCode ^
      images.hashCode ^
      tags.hashCode;
}

@immutable
class Images {
  const Images({
    required this.image460,
    this.image460sv,
  });

  final Image460 image460;
  final Image460sv? image460sv;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
      image460: Image460.fromJson(json['image460'] as Map<String, dynamic>),
      image460sv: json['image460sv'] != null
          ? Image460sv.fromJson(json['image460sv'] as Map<String, dynamic>)
          : null);

  Map<String, dynamic> toJson() =>
      {'image460': image460.toJson(), 'image460sv': image460sv?.toJson()};

  Images clone() =>
      Images(image460: image460.clone(), image460sv: image460sv?.clone());

  Images copyWith({Image460? image460, Optional<Image460sv?>? image460sv}) =>
      Images(
        image460: image460 ?? this.image460,
        image460sv: checkOptional(image460sv, () => this.image460sv),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Images &&
          image460 == other.image460 &&
          image460sv == other.image460sv;

  @override
  int get hashCode => image460.hashCode ^ image460sv.hashCode;
}

@immutable
class Image460 {
  const Image460({
    required this.url,
  });

  final String url;

  factory Image460.fromJson(Map<String, dynamic> json) =>
      Image460(url: json['url'].toString());

  Map<String, dynamic> toJson() => {'url': url};

  Image460 clone() => Image460(url: url);

  Image460 copyWith({String? url}) => Image460(
        url: url ?? this.url,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Image460 && url == other.url;

  @override
  int get hashCode => url.hashCode;
}

@immutable
class Image460sv {
  const Image460sv({
    required this.url,
    required this.hasAudio,
    required this.duration,
  });

  final String url;
  final int hasAudio;
  final int duration;

  factory Image460sv.fromJson(Map<String, dynamic> json) => Image460sv(
      url: json['url'].toString(),
      hasAudio: json['hasAudio'] as int,
      duration: json['duration'] as int);

  Map<String, dynamic> toJson() =>
      {'url': url, 'hasAudio': hasAudio, 'duration': duration};

  Image460sv clone() =>
      Image460sv(url: url, hasAudio: hasAudio, duration: duration);

  Image460sv copyWith({String? url, int? hasAudio, int? duration}) =>
      Image460sv(
        url: url ?? this.url,
        hasAudio: hasAudio ?? this.hasAudio,
        duration: duration ?? this.duration,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Image460sv &&
          url == other.url &&
          hasAudio == other.hasAudio &&
          duration == other.duration;

  @override
  int get hashCode => url.hashCode ^ hasAudio.hashCode ^ duration.hashCode;
}

@immutable
class Tag {
  const Tag({
    required this.key,
    this.url,
    this.description,
  });

  final String key;
  final String? url;
  final String? description;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
      key: json['key'].toString(),
      url: json['url']?.toString(),
      description: json['description']?.toString());

  Map<String, dynamic> toJson() =>
      {'key': key, 'url': url, 'description': description};

  Tag clone() => Tag(key: key, url: url, description: description);

  Tag copyWith(
          {String? key,
          Optional<String?>? url,
          Optional<String?>? description}) =>
      Tag(
        key: key ?? this.key,
        url: checkOptional(url, () => this.url),
        description: checkOptional(description, () => this.description),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          key == other.key &&
          url == other.url &&
          description == other.description;

  @override
  int get hashCode => key.hashCode ^ url.hashCode ^ description.hashCode;
}
