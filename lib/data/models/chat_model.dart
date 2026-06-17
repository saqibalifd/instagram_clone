import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final String lastSenderId;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    this.lastMessageTime,
    required this.lastSenderId,
  });

  factory ChatModel.fromJson(String chatId, Map<String, dynamic> json) {
    return ChatModel(
      chatId: chatId,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'],
      lastSenderId: json['lastSenderId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastSenderId': lastSenderId,
    };
  }
}
