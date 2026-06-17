import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final bool isSeen;
  final dynamic timestamp; // changed

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.isSeen,
    this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'text',
      isSeen: json['isSeen'] ?? false,
      timestamp: json['timestamp'], // can be Timestamp or null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'isSeen': isSeen,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  /// helper to get readable DateTime
  DateTime? get createdAt {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return (timestamp as Timestamp).toDate();
    return null;
  }
}
