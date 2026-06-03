// // ============================================================
// //  WHAT GOES HERE
// //  GetMiddleware that guards protected routes.
// //  redirect() returns null (allow) if signed in,
// //  or RouteSettings(AppRoutes.login) to kick unauthenticated
// //  users to the login screen.
// //  Add to GetPage.middlewares for every protected route.
// // ============================================================

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../services/firebase_service.dart';
// import 'app_routes.dart';

// class AuthMiddleware extends GetMiddleware {
//   @override int? get priority => 1;

//   @override
//   RouteSettings? redirect(String? route) {
//     final signedIn = Get.find<FirebaseService>().isSignedIn;
//     return signedIn ? null : const RouteSettings(name: AppRoutes.login);
//   }
// }
