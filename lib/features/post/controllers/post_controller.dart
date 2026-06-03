// ============================================================
//  WHAT GOES HERE
//  Create-post logic:
//    * body text state
//    * image picker -> Storage upload -> collect URLs
//    * submit to PostRepository.createPost()
//    * pop on success, Snackbar on failure
// ============================================================

import 'package:get/get.dart';
import '../../../data/repositories/interfaces/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _repo;
  PostController(this._repo);

  final body         = ''.obs;
  final imageUrls    = <String>[].obs;
  final isSubmitting = false.obs;

  Future<void> submitPost() async {
    if (body.value.trim().isEmpty) return;
    isSubmitting.value = true;
    try {
      await _repo.createPost(body: body.value, imageUrls: imageUrls);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally { isSubmitting.value = false; }
  }
}
