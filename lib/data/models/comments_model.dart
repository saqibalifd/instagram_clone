import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String username;
  final String fullName;
  final String profilePicture;
  final String text;
  final DateTime createdAt;
  final int likesCount;
  final bool isEdited;
  final String? parentCommentId; // For replies

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.profilePicture,
    required this.text,
    required this.createdAt,
    this.likesCount = 0,
    this.isEdited = false,
    this.parentCommentId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CommentModel(
      id: documentId,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likesCount: map['likesCount'] ?? 0,
      isEdited: map['isEdited'] ?? false,
      parentCommentId: map['parentCommentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'text': text,
      'createdAt': createdAt,
      'likesCount': likesCount,
      'isEdited': isEdited,
      'parentCommentId': parentCommentId,
    };
  }
}
