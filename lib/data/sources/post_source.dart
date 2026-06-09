// // ============================================================
// //  WHAT GOES HERE
// //  Firestore reads/writes for posts.
// //  The ONLY file allowed to import cloud_firestore for posts.
// //  Pagination uses startAfterDocument for cursor-based paging.
// // ============================================================

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/post_model.dart';
// import '../../core/constants/app_constants.dart';

// class PostSource {
//   final FirebaseFirestore _db;
//   PostSource(this._db);

//   Future<List<PostModel>> getFeedPosts({int limit = 20, String? afterId}) async {
//     var q = _db.collection(AppConstants.postsCollection)
//                .orderBy('createdAt', descending: true)
//                .limit(limit);

//     if (afterId != null) {
//       final snap = await _db.collection(AppConstants.postsCollection).doc(afterId).get();
//       q = q.startAfterDocument(snap);
//     }

//     final res = await q.get();
//     return res.docs.map((d) => PostModel.fromJson({'id': d.id, ...d.data()})).toList();
//   }

//   Future<PostModel> createPost({required String body, List<String> imageUrls = const []}) async {
//     final ref = _db.collection(AppConstants.postsCollection).doc();
//     final post = PostModel(
//       id: ref.id, authorId: 'currentUserId', // TODO: inject real uid
//       body: body, imageUrls: imageUrls, createdAt: DateTime.now(),
//     );
//     await ref.set(post.toJson());
//     return post;
//   }

//   Future<void> likePost(String postId, String userId) =>
//       _db.collection(AppConstants.postsCollection).doc(postId).update(
//             {'likesCount': FieldValue.increment(1)});

//   Future<void> deletePost(String postId) =>
//       _db.collection(AppConstants.postsCollection).doc(postId).delete();
// }
