import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/chat_model.dart';
import 'package:instagram/data/models/message_model.dart';
import '../../../data/models/user_model.dart';

class DmController extends GetxController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  RxList<UserModel> friendsUsers = <UserModel>[].obs;
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  final List<StreamSubscription> _friendSubs = [];

  @override
  void onInit() {
    super.onInit();
    loadFriendsStream();
  }

  @override
  void onClose() {
    for (final sub in _friendSubs) {
      sub.cancel();
    }
    super.onClose();
  }

  // =========================
  // CHAT ID
  // =========================
  String generateChatId(String currentUserId, String otherUserId) {
    final ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(currentUserId, receiverId);

    final msgRef = _firebase
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .doc();

    MessageModel messageModel = MessageModel(
      id: msgRef.id,
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      type: 'text',
      isSeen: false,
      timestamp: FieldValue.serverTimestamp(),
    );

    await msgRef.set(messageModel.toJson());

    ChatModel chatModel = ChatModel(
      chatId: chatId,
      participants: [currentUserId, receiverId],
      lastMessage: message,
      lastSenderId: currentUserId,
      lastMessageTime: FieldValue.serverTimestamp(),
    );

    await _firebase
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .set(chatModel.toJson(), SetOptions(merge: true));
  }

  // =========================
  // GET MESSAGES STREAM
  // =========================
  Stream<QuerySnapshot> getMessages(String receiverId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(currentUserId, receiverId);

    return _firebase
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp')
        .snapshots();
  }

  // =========================
  // LOAD FRIENDS (REAL TIME)
  // =========================
  Future<void> loadFriendsStream() async {
    try {
      isLoading.value = true;

      final currentUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final data = currentUserDoc.data();
      if (data == null) {
        friendsUsers.clear();

        return;
      }

      final List<String> followers = List<String>.from(data['followers'] ?? []);

      final List<String> following = List<String>.from(data['following'] ?? []);

      final Set<String> friendIds = followers.toSet().intersection(
        following.toSet(),
      );

      if (friendIds.isEmpty) {
        friendsUsers.clear();
        return;
      }

      // cancel old listeners
      for (final sub in _friendSubs) {
        sub.cancel();
      }
      _friendSubs.clear();

      final chunks = _chunkList(friendIds.toList(), 10);

      for (final chunk in chunks) {
        final sub = _firebase
            .collection(AppConstants.usersCollection)
            .where('userId', whereIn: chunk)
            .snapshots()
            .listen((snapshot) {
              final updatedUsers = snapshot.docs
                  .map((doc) => UserModel.fromJson(doc.data()))
                  .toList();

              // merge safely (avoid duplicates)
              final Map<String, UserModel> map = {
                for (var u in friendsUsers) u.userId: u,
              };

              for (var u in updatedUsers) {
                map[u.userId] = u;
              }

              friendsUsers.assignAll(map.values.toList());
            });

        _friendSubs.add(sub);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // CHUNK HELPER
  // =========================
  List<List<T>> _chunkList<T>(List<T> list, int size) {
    final chunks = <List<T>>[];

    for (int i = 0; i < list.length; i += size) {
      chunks.add(
        list.sublist(i, i + size > list.length ? list.length : i + size),
      );
    }

    return chunks;
  }
}
