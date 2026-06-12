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
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Saqib Ali',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      caption: 'Enjoying Flutter development 🚀',
      mediaUrl: 'https://picsum.photos/id/1011/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Lahore, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Nice!', 'Awesome 🔥'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '2',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Ali Khan',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      caption:
          'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since 1966, when designers at Letraset and James Mosley, the librarian at St Bride Printing Library, took a 1914 Cicero translation and scrambled it to make dummy text for Letrasets Body Type sheets. It has survived not only many decades, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised thanks to these sheets and more recently with desktop publishing software including versions of Lorem Ipsum.',
      mediaUrl: 'https://picsum.photos/id/1025/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Islamabad, Pakistan',
      likes: ['user_1'],
      comments: ['Great work!'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '3',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Ahmed Raza',
      profileImageUrl: 'https://i.pravatar.cc/150?img=3',
      caption: 'Weekend vibes 🌴',
      mediaUrl: 'https://picsum.photos/id/1035/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Karachi, Pakistan',
      likes: ['user_1', 'user_2', 'user_5'],
      comments: ['Beautiful 😍', 'Nice click'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '4',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Hamza',
      profileImageUrl: 'https://i.pravatar.cc/150?img=4',
      caption: 'Morning coffee ☕',
      mediaUrl: 'https://picsum.photos/id/1060/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Faisalabad, Pakistan',
      likes: ['user_1', 'user_3'],
      comments: ['Looks tasty'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '5',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Ayesha',
      profileImageUrl: 'https://i.pravatar.cc/150?img=5',
      caption: 'Nature never disappoints 🍃',
      mediaUrl: 'https://picsum.photos/id/1040/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Murree, Pakistan',
      likes: ['user_1', 'user_2', 'user_3', 'user_4'],
      comments: ['Amazing view!', 'Love this ❤️'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '6',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Fatima',
      profileImageUrl: 'https://i.pravatar.cc/150?img=6',
      caption: 'Travel memories ✈️',
      mediaUrl: 'https://picsum.photos/id/1050/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Skardu, Pakistan',
      likes: ['user_1', 'user_5'],
      comments: ['Wow 😍', 'Dream place'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '7',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Bilal',
      profileImageUrl: 'https://i.pravatar.cc/150?img=7',
      caption: 'Gym session completed 💪',
      mediaUrl: 'https://picsum.photos/id/1074/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Multan, Pakistan',
      likes: ['user_2', 'user_3'],
      comments: ['Keep going bro 🔥'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
      visibility: 'public',
      allowComments: true,
      hideFrom: [],
    ),

    PostModel(
      postId: '8',
      userId: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
      userName: 'Zain',
      profileImageUrl: 'https://i.pravatar.cc/150?img=8',
      caption: 'Sunset photography 📸',
      mediaUrl: 'https://picsum.photos/id/1084/600/800',
      mediaType: 'image',
      isVideo: false,
      createdAt: DateTime.now(),
      location: 'Gwadar, Pakistan',
      likes: ['user_1', 'user_4', 'user_6'],
      comments: ['Perfect shot!', 'Awesome colors'],
      tags: [],
      repostBy: [],
      favorites: [],
      viewsBy: [],
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
