import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/user_model.dart';

class PublicProfileController extends GetxController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  Future<void> loadPublicProfile(String userId) async {
    try {
      isLoading.value = true;
      final doc = await _firebase
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        user.value = UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
