import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String profileImageUrl;
  final String caption;
  final String mediaUrl;
  final String mediaType;
  final Timestamp createdAt;
  final String location;

  final List<String> likes;
  final List<String> comments;

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
    required this.createdAt,
    required this.location,
    required this.likes,
    required this.comments,
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
      createdAt: json['createdAt'] ?? Timestamp.now(),
      location: json['location'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
      visibility: json['visibility'] ?? 'public',
      allowComments: json['allowComments'] ?? true,
      hideFrom: List<String>.from(json['hideFrom'] ?? []),
    );
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
      'createdAt': createdAt,
      'location': location,
      'likes': likes,
      'comments': comments,
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
    Timestamp? createdAt,
    String? location,
    List<String>? likes,
    List<String>? comments,
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
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      visibility: visibility ?? this.visibility,
      allowComments: allowComments ?? this.allowComments,
      hideFrom: hideFrom ?? this.hideFrom,
    );
  }
}
