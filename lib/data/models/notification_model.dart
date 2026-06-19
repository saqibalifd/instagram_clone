import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String senderId;
  final String senderName;
  final String senderProfileImage;
  final String title;
  final String postId;
  final String postImage;
  final String type; // like, comment, follow, mention
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.senderId,
    required this.senderName,
    required this.senderProfileImage,
    required this.title,
    required this.postId,
    required this.postImage,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderProfileImage: map['senderProfileImage'] ?? '',
      title: map['title'] ?? '',
      postId: map['postId'] ?? '',
      postImage: map['postImage'] ?? '',
      type: map['type'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileImage': senderProfileImage,
      'title': title,
      'postId': postId,
      'postImage': postImage,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }
}
