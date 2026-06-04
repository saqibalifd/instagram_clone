// // ============================================================
// //  WHAT GOES HERE
// //  App-wide DI — registered ONCE at startup before any route.
// //  Registration order: Services → Sources → Repositories.
// //  Use Get.put()     for always-alive singletons (services).
// //  Use Get.lazyPut() for things created on first access.
// //
// //  SharedPreferences must be awaited in main() then passed in:
// //    Get.put(LocalStorage(prefs));  // see main.dart
// // ============================================================

// import 'package:get/get.dart';
// import '../data/repositories/implementations/auth_repository_impl.dart';
// import '../data/repositories/implementations/post_repository_impl.dart';
// import '../data/repositories/interfaces/auth_repository.dart';
// import '../data/repositories/interfaces/post_repository.dart';
// import '../data/sources/auth_source.dart';
// import '../data/sources/post_source.dart';
// import '../services/fcm_service.dart';
// import '../services/firebase_service.dart';

// class InitialBindings extends Bindings {
//   @override
//   void dependencies() {
//     // 1️⃣  Services — always alive
//     Get.put<FirebaseService>(FirebaseService());
//     Get.put<FcmService>(FcmService()..init());

//     // 2️⃣  Sources — lazy, need services
//     Get.lazyPut<AuthSource>(() => AuthSource(Get.find<FirebaseService>().auth));
//     Get.lazyPut<PostSource>(() => PostSource(Get.find<FirebaseService>().firestore));

//     // 3️⃣  Repositories — lazy, need sources
//     Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthSource>()));
//     Get.lazyPut<PostRepository>(() => PostRepositoryImpl(Get.find<PostSource>()));

//     // 4️⃣  LocalStorage is registered in main() after await SharedPreferences
//   }
// }
