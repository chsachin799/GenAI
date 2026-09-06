import 'dart:convert';

enum ResourceType { youtube, github, figma, devpost, article, doc, general }

class ResourceLinkModel {
  final String id;
  final String title;
  final String url;
  final ResourceType type;

  ResourceLinkModel({
    required this.id,
    required this.title,
    required this.url,
    this.type = ResourceType.general,
  });

  static ResourceType detectType(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
      return ResourceType.youtube;
    } else if (lower.contains('github.com')) {
      return ResourceType.github;
    } else if (lower.contains('figma.com')) {
      return ResourceType.figma;
    } else if (lower.contains('devpost.com') || lower.contains('devfolio.co')) {
      return ResourceType.devpost;
    } else if (lower.contains('medium.com') || lower.contains('substack.com') || lower.contains('hashnode.dev')) {
      return ResourceType.article;
    } else if (lower.contains('docs.') || lower.contains('notion.site') || lower.contains('drive.google.com')) {
      return ResourceType.doc;
    }
    return ResourceType.general;
  }

  ResourceLinkModel copyWith({
    String? id,
    String? title,
    String? url,
    ResourceType? type,
  }) {
    return ResourceLinkModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type.index,
    };
  }

  factory ResourceLinkModel.fromMap(Map<String, dynamic> map) {
    return ResourceLinkModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: ResourceType.values[map['type'] ?? ResourceType.general.index],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceLinkModel.fromJson(String source) =>
      ResourceLinkModel.fromMap(json.decode(source));
}
