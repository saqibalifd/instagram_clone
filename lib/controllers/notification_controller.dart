import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/notification_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.put(ProfileController());
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<NotificationModel> notificationsList = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNotifications();
  }

  // Fetch ALL posts from Firestore

  Future<void> fetchAllNotifications() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.notificationsCollection)
          .where('senderId', isNotEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            notificationsList.value = snapshot.docs
                .map((doc) => NotificationModel.fromMap(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Error in fetching all notifications: ${e.message}');
    } catch (e) {
      print('Error in fetching all notifications: ${e.toString()}');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadNotifications(String caption) async {
    try {
      isLoading.value = true;

      DocumentReference docRef = _firebase
          .collection(AppConstants.notificationsCollection)
          .doc();
      final currentUser = profileController.profileUser.value;
      final NotificationModel notificationModel = NotificationModel(
        notificationId: docRef.id,
        senderId: currentUser!.userId,
        senderName: currentUser.username,
        senderProfileImage: currentUser.profileImageUrl,
        title: 'Ali liked your post',
        postId: '',
        postImage:
            'https://www.whitcoulls.co.nz/content/products/9780008792183.jpg?enable=upscale&canvas=2:3&auto=webp&optimize=high&width=248',
        type: 'follow',
        createdAt: DateTime.now(),
      );
      docRef.set(notificationModel.toMap()).then((value) {
        _firebase.collection(AppConstants.usersCollection).doc(userId).update({
          'posts': FieldValue.arrayUnion([docRef.id]),
        });
      });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } catch (e) {
      error.value = AppConstants.commonErrorMessage;
    } finally {
      isLoading.value = false;
    }
  }
}
