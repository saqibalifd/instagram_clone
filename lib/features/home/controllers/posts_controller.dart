import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/data/models/post_model.dart';
import 'package:instagram/utils/loading_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/user_model.dart';

class PostsController extends GetxController {
  late final LocalStorageService _localStorage;
  final _firebase = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final supabase = Supabase.instance.client;

  final profileUser = Rxn<UserModel>();
  final fetchLoading = false.obs;
  final updateLoading = false.obs;
  final isLoading = false.obs;

  final RxList<PostModel> posts = <PostModel>[
    PostModel(
      postId: '1',
      userId: 'user_1',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '2',
      userId: 'user_2',
      userName: 'Ali Khan',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      caption: 'Working on my new app 💻',
      mediaUrl: 'https://picsum.photos/id/1025/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Islamabad, Pakistan',
      likes: ['user_1'],
      comments: ['Great work!'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '3',
      userId: 'user_3',
      userName: 'Ahmed Raza',
      profileImageUrl: 'https://i.pravatar.cc/150?img=3',
      caption: 'Weekend vibes 🌴',
      mediaUrl: 'https://picsum.photos/id/1035/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Karachi, Pakistan',
      likes: ['user_1', 'user_2', 'user_5'],
      comments: ['Beautiful 😍', 'Nice click'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '4',
      userId: 'user_4',
      userName: 'Hamza',
      profileImageUrl: 'https://i.pravatar.cc/150?img=4',
      caption: 'Morning coffee ☕',
      mediaUrl: 'https://picsum.photos/id/1060/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Faisalabad, Pakistan',
      likes: ['user_1', 'user_3'],
      comments: ['Looks tasty'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '5',
      userId: 'user_5',
      userName: 'Ayesha',
      profileImageUrl: 'https://i.pravatar.cc/150?img=5',
      caption: 'Nature never disappoints 🍃',
      mediaUrl: 'https://picsum.photos/id/1040/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Murree, Pakistan',
      likes: ['user_1', 'user_2', 'user_3', 'user_4'],
      comments: ['Amazing view!', 'Love this ❤️'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '6',
      userId: 'user_6',
      userName: 'Fatima',
      profileImageUrl: 'https://i.pravatar.cc/150?img=6',
      caption: 'Travel memories ✈️',
      mediaUrl: 'https://picsum.photos/id/1050/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Skardu, Pakistan',
      likes: ['user_1', 'user_5'],
      comments: ['Wow 😍', 'Dream place'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '7',
      userId: 'user_7',
      userName: 'Bilal',
      profileImageUrl: 'https://i.pravatar.cc/150?img=7',
      caption: 'Gym session completed 💪',
      mediaUrl: 'https://picsum.photos/id/1074/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Multan, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Keep going bro 🔥'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '8',
      userId: 'user_8',
      userName: 'Zain',
      profileImageUrl: 'https://i.pravatar.cc/150?img=8',
      caption: 'Sunset photography 📸',
      mediaUrl: 'https://picsum.photos/id/1084/600/800',
      mediaType: 'image',
      createdAt: Timestamp.now(),
      location: 'Gwadar, Pakistan',
      likes: ['user_1', 'user_4', 'user_6'],
      comments: ['Perfect shot!', 'Awesome colors'],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),
  ].obs;
  @override
  void onInit() {
    super.onInit();

    _localStorage = Get.put<LocalStorageService>(LocalStorageService());

    loadLocalProfile();
  }

  Future<void> loadLocalProfile() async {
    isLoading.value = true;

    final user = _localStorage.getUser();

    profileUser.value = user;

    isLoading.value = false;
  }

  Future<void> uploadPosts() async {
    try {} on FirebaseException catch (e) {
    } catch (e) {
    } finally {
      LoadingUtil.dismiss();
    }
  }
}
