import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/chat_model.dart';
import 'package:instagram/data/models/message_model.dart';
import 'package:instagram/services/send_notification_service.dart';
import '../../../data/models/user_model.dart';

class DmController extends GetxController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  RxList<UserModel> friendsUsers = <UserModel>[].obs;
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  StreamSubscription? _currentUserSub; // streams the current user doc
  final List<StreamSubscription> _friendSubs = [];

  @override
  void onInit() {
    super.onInit();
    _listenToCurrentUser();
  }

  @override
  void onClose() {
    _currentUserSub?.cancel();
    _cancelFriendSubs();
    super.onClose();
  }

  // =========================
  // LISTEN TO CURRENT USER (real-time)
  // =========================
  void _listenToCurrentUser() {
    isLoading.value = true;

    _currentUserSub = _firebase
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .listen(
          (doc) {
            final data = doc.data();
            if (data == null) {
              friendsUsers.clear();
              isLoading.value = false;
              return;
            }

            final List<String> followers = List<String>.from(
              data['followers'] ?? [],
            );
            final List<String> following = List<String>.from(
              data['following'] ?? [],
            );
            final Set<String> friendIds = followers.toSet().intersection(
              following.toSet(),
            );

            if (friendIds.isEmpty) {
              friendsUsers.clear();
              isLoading.value = false;
              return;
            }

            _listenToFriends(friendIds);
          },
          onError: (e) {
            error.value = e.toString();
            isLoading.value = false;
          },
        );
  }

  // =========================
  // LISTEN TO FRIENDS (real-time, chunked)
  // =========================
  void _listenToFriends(Set<String> friendIds) {
    _cancelFriendSubs(); // cancel stale listeners before re-subscribing

    final chunks = _chunkList(friendIds.toList(), 10);
    // Track how many chunks have fired at least once
    final Set<int> loadedChunks = {};

    for (int i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      final chunkIndex = i;

      final sub = _firebase
          .collection(AppConstants.usersCollection)
          .where('userId', whereIn: chunk)
          .snapshots()
          .listen(
            (snapshot) {
              final updatedUsers = snapshot.docs
                  .map((doc) => UserModel.fromJson(doc.data()))
                  .toList();

              // Merge into the shared map (avoid duplicates)
              final Map<String, UserModel> map = {
                for (var u in friendsUsers) u.userId: u,
              };
              for (var u in updatedUsers) {
                map[u.userId] = u;
              }
              friendsUsers.assignAll(map.values.toList());

              // Only stop loading once every chunk has emitted at least once
              loadedChunks.add(chunkIndex);
              if (loadedChunks.length == chunks.length) {
                isLoading.value = false;
              }
            },
            onError: (e) {
              error.value = e.toString();
              isLoading.value = false;
            },
          );

      _friendSubs.add(sub);
    }
  }

  void _cancelFriendSubs() {
    for (final sub in _friendSubs) {
      sub.cancel();
    }
    _friendSubs.clear();
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> sendMessage({
    required String receiverId,
    required String message,
    required String token,
    required String fullName,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(currentUserId, receiverId);

    final msgRef = _firebase
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .doc();

    final messageModel = MessageModel(
      id: msgRef.id,
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      type: 'text',
      isSeen: false,
      timestamp: FieldValue.serverTimestamp(),
    );

    await msgRef.set(messageModel.toJson());

    final chatModel = ChatModel(
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
    await SendNotificationService.sendNotificationUsingApi(
      token: token,
      title: fullName,
      body: message,
      data: {},
    );
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
  // CHAT ID
  // =========================
  String generateChatId(String currentUserId, String otherUserId) {
    final ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
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
