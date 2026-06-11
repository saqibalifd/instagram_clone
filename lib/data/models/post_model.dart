import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String profileImageUrl;
  final String caption;
  final String mediaUrl;
  final String mediaType;

  final bool isVideo;

  final DateTime createdAt;

  final String location;

  final List<String> likes;
  final List<String> comments;

  final List<String> tags;
  final List<String> repostBy;
  final List<String> favorites;
  final List<String> viewsBy;

  final String visibility;
  final bool allowComments;
  final List<String> hideFrom;

  const PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.caption,
    required this.mediaUrl,
    required this.mediaType,
    required this.isVideo,
    required this.createdAt,
    required this.location,
    required this.likes,
    required this.comments,
    required this.tags,
    required this.repostBy,
    required this.favorites,
    required this.viewsBy,

    required this.visibility,
    required this.allowComments,
    required this.hideFrom,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      caption: json['caption'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',

      isVideo: json['isVideo'] ?? false,

      createdAt: _parseDateTime(json['createdAt']),

      location: json['location'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),

      tags: List<String>.from(json['tags'] ?? []),
      repostBy: List<String>.from(json['repostBy'] ?? []),
      favorites: List<String>.from(json['favorites'] ?? []),
      viewsBy: List<String>.from(json['viewsBy'] ?? []),

      visibility: json['visibility'] ?? 'public',
      allowComments: json['allowComments'] ?? true,
      hideFrom: List<String>.from(json['hideFrom'] ?? []),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) return value.toDate();

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'caption': caption,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,

      'isVideo': isVideo,

      'createdAt': createdAt.millisecondsSinceEpoch,

      'location': location,
      'likes': likes,
      'comments': comments,

      'tags': tags,
      'repostBy': repostBy,
      'favorites': favorites,
      'viewsBy': viewsBy,

      'visibility': visibility,
      'allowComments': allowComments,
      'hideFrom': hideFrom,
    };
  }

  PostModel copyWith({
    String? postId,
    String? userId,
    String? userName,
    String? profileImageUrl,
    String? caption,
    String? mediaUrl,
    String? mediaType,
    bool? isVideo,
    DateTime? createdAt,
    String? location,
    List<String>? likes,
    List<String>? comments,
    List<String>? tags,
    List<String>? repostBy,
    List<String>? favorites,
    List<String>? viewsBy,
    String? visibility,
    bool? allowComments,
    List<String>? hideFrom,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      caption: caption ?? this.caption,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      isVideo: isVideo ?? this.isVideo,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      repostBy: repostBy ?? this.repostBy,
      favorites: favorites ?? this.favorites,
      viewsBy: viewsBy ?? this.viewsBy,
      visibility: visibility ?? this.visibility,
      allowComments: allowComments ?? this.allowComments,
      hideFrom: hideFrom ?? this.hideFrom,
    );
  }
}
