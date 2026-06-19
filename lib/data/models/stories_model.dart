import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String storyId;
  final String userId;
  final String userName;
  final String profileImageUrl;

  final String mediaUrl;
  final String mediaType; // image, video

  final String caption;
  final String musicTitle;
  final String musicUrl;

  final DateTime createdAt;
  final DateTime expiresAt;

  final List<String> viewedBy;
  final List<String> likedBy;
  final List<String> mentions;

  final String visibility; // public, followers, closeFriends
  final bool isHighlighted;
  final String highlightId;

  const StoryModel({
    required this.storyId,
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.mediaUrl,
    required this.mediaType,
    required this.caption,
    required this.musicTitle,
    required this.musicUrl,
    required this.createdAt,
    required this.expiresAt,
    required this.viewedBy,
    required this.likedBy,
    required this.mentions,
    required this.visibility,
    required this.isHighlighted,
    required this.highlightId,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['storyId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',
      caption: json['caption'] ?? '',
      musicTitle: json['musicTitle'] ?? '',
      musicUrl: json['musicUrl'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
      viewedBy: List<String>.from(json['viewedBy'] ?? []),
      likedBy: List<String>.from(json['likedBy'] ?? []),
      mentions: List<String>.from(json['mentions'] ?? []),
      visibility: json['visibility'] ?? 'followers',
      isHighlighted: json['isHighlighted'] ?? false,
      highlightId: json['highlightId'] ?? '',
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
      'storyId': storyId,
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'caption': caption,
      'musicTitle': musicTitle,
      'musicUrl': musicUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'viewedBy': viewedBy,
      'likedBy': likedBy,
      'mentions': mentions,
      'visibility': visibility,
      'isHighlighted': isHighlighted,
      'highlightId': highlightId,
    };
  }

  StoryModel copyWith({
    String? storyId,
    String? userId,
    String? userName,
    String? profileImageUrl,
    String? mediaUrl,
    String? mediaType,
    String? caption,
    String? musicTitle,
    String? musicUrl,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewedBy,
    List<String>? likedBy,
    List<String>? mentions,
    String? visibility,
    bool? isHighlighted,
    String? highlightId,
  }) {
    return StoryModel(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      caption: caption ?? this.caption,
      musicTitle: musicTitle ?? this.musicTitle,
      musicUrl: musicUrl ?? this.musicUrl,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewedBy: viewedBy ?? this.viewedBy,
      likedBy: likedBy ?? this.likedBy,
      mentions: mentions ?? this.mentions,
      visibility: visibility ?? this.visibility,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      highlightId: highlightId ?? this.highlightId,
    );
  }
}
