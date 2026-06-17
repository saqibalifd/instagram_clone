import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';

class DmController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final RxString error = ''.obs;

  RxList<UserModel> friendsUsers = <UserModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFriendsStream();
  }

  String generateChatId(String currentUserId, String otherUserId) {
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final chatId = generateChatId(currentUserId, receiverId);

    final msgRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'id': msgRef.id,
      'senderId': currentUserId,
      'receiverId': receiverId,
      'message': message,
      'type': 'text',
      'isSeen': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'participants': [currentUserId, receiverId],
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': currentUserId,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String receiverId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final chatId = generateChatId(currentUserId, receiverId);

    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> loadFriendsStream() async {
    try {
      isLoading.value = true;

      // Step 1: Get current user's followers and following lists once
      final currentUserDoc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      final currentUserData = currentUserDoc.data();
      if (currentUserData == null) return;

      final List<String> myFollowers = List<String>.from(
        currentUserData['followers'] ?? [],
      );
      final List<String> myFollowing = List<String>.from(
        currentUserData['following'] ?? [],
      );

      // Step 2: Friends = users who are in BOTH followers and following
      final Set<String> friendIds = myFollowers.toSet().intersection(
        myFollowing.toSet(),
      );

      if (friendIds.isEmpty) {
        friendsUsers.assignAll([]);
        return;
      }

      // Step 3: Listen to real-time updates of only those friend documents
      // Firestore 'whereIn' supports max 10 ids per query, so we chunk if needed
      final List<List<String>> chunks = _chunkList(friendIds.toList(), 10);

      // Combine all chunk streams
      final List<UserModel> allFriends = [];

      for (final chunk in chunks) {
        final snapshot = await _firebase
            .collection(AppConstants.usersCollection)
            .where('userId', whereIn: chunk)
            .get();

        final users = snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();

        allFriends.addAll(users);
      }

      friendsUsers.assignAll(allFriends);
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}
