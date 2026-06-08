import 'package:get/get.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/post_model.dart';

class ProfileController extends GetxController {
  late final LocalStorageService _localStorage;

  final profileUser = Rxn<UserModel>();
  final userPosts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isFollowing = false.obs;

  @override
  void onInit() {
    super.onInit();

    _localStorage = Get.put<LocalStorageService>(LocalStorageService());

    loadLocalProfile();
  }

  /// 🔥 LOAD FROM LOCAL STORAGE
  Future<void> loadLocalProfile() async {
    isLoading.value = true;

    final user = _localStorage.getUser();

    profileUser.value = user;

    isLoading.value = false;
  }

  /// (optional) server sync later
  Future<void> loadProfileFromServer(String userId) async {
    isLoading.value = true;

    // profileUser.value = await userRepo.getUser(userId);

    isLoading.value = false;
  }

  Future<void> toggleFollow() async {
    isFollowing.toggle();
  }
}
