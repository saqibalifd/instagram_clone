import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.put(ProfileController());
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<PostModel> allPostsList = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection(AppConstants.postsCollection)
          .snapshots()
          .listen((snapshot) {
            allPostsList.value = snapshot.docs
                .map((doc) => PostModel.fromJson(doc.data()))
                .toList();
          });
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
      print('Errror in ferching posts ***********************************');
      print(e.message);
    } catch (e) {
      print(
        'Errror in ferching posts *********************************** another *******',
      );
      print(e.toString());

      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadPosts(String caption) async {
    try {
      isLoading.value = true;

      DocumentReference docRef = _firebase
          .collection(AppConstants.postsCollection)
          .doc();
      final currentUser = profileController.profileUser.value;
      final PostModel postModel = PostModel(
        postId: docRef.id,
        userId: userId,
        userName: currentUser!.username,
        profileImageUrl: currentUser.profileImageUrl,
        caption: caption,
        mediaUrl:
            'https://images.squarespace-cdn.com/content/v1/585174d6893fc0a6ea9567ab/1537365663766-SKXOENZGGYKI95CG916G/ke17ZwdGBToddI8pDm48kKKPzNC1pd5EwhDtJFdEcXoUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8PaoYXhp6HxIwZIk7-Mi3Tsic-L2IOPH3Dwrhl-Ne3Z2mxGOWoiEtYlj1y8uCs380-4Wg86iwZgYfMpFyqLFaCUKMshLAGzx4R3EDFOm1kBS/How+To+Take+Beautiful+Instagram+Photos+%2F%2F+Ebook+by+Olivia+Bossert+%2F%2F+www.oliviabossert.com+%2F%2F+social+media+tips%2C+Instagram+tips%2C+Instagram+photography+tips%2C+Instagram+followers%2C+grow+your+Instagram%2C+Instagram+theme%2C+Instagram+grid%2C+social+media+photography%2C+photography+tips%2C+smartphone+photography+tips%2C+marketing+tips%2C+small+business+tips%2C+cheap+ebook+on+Instagram%2C+ebook+about+Instagram%2C+ebook+about+Instagram+photography%2C+ebook+about+photography%2C+ebook+about+smartphone+photography%2C+ebook+about+branding+photography%2C+olivia+bossert+photography%2C+instagram+advice%2C+photography+advice%2C+marketing+advice?format=original',
        mediaType: 'image',
        isVideo: false,
        createdAt: DateTime.now(),
        location: 'Lahore, Pakistan',
        likes: [],
        comments: [],
        tags: [],
        repostBy: [],
        favorites: [],
        viewsBy: [],
        visibility: 'public',
        allowComments: true,
        hideFrom: [],
        reports: [],
      );

      docRef.set(postModel.toJson());
    } on FirebaseException catch (e) {
      error.value = e.message.toString();
    } catch (e) {
      error.value = AppConstants.commonErrorMessage;
    } finally {
      isLoading.value = false;
    }
  }
}
