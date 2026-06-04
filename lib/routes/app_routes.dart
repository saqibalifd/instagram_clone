// ============================================================
//  WHAT GOES HERE
//  Route name constants — use these everywhere you call
//  Get.toNamed() or Get.offAllNamed() so strings never get
//  hardcoded inside views or controllers.
// ============================================================

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String phoneAuth = '/phoneAuth';
  static const String otp = '/otp';
  static const String bottomNavbar = '/bottomNavbar';
  static const String feed = '/feed';
  static const String createPost = '/post/create';
  static const String profile = '/profile/:userId';

  // Helper for parameterised routes
  static String profileOf(String userId) => '/profile/$userId';
}
