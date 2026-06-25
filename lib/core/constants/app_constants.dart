import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Instagram';
  static const String commonErrorMessage =
      'Something went wrong. Please try again.';
  static const int maxPostLength = 500;
  static const int feedPageSize = 20;
  static double horizontalSmallPadding = 20.w;
  static double horizontalMediumPadding = 40.w;
  static double horizontalLargePadding = 60.w;
  static const Duration splashDuration = Duration(seconds: 3);

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String storiesCollection = 'stories';
  static const String chatsCollection = 'chats';
  static const String notificationsCollection = 'notifications';
  static const String messagesCollection = 'messages';
  static const String commentsCollection = 'comments';

  //supabase bucket name
  static const String bucketName = 'public';
}
