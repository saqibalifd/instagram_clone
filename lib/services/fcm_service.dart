// ============================================================
//  WHAT GOES HERE
//  Firebase Cloud Messaging setup:
//    • Request notification permission
//    • Get / refresh FCM token → save to Firestore user doc
//    • Handle foreground messages (show in-app banner)
//    • Handle notification tap → navigate to correct screen
// ============================================================

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    final token = await _fcm.getToken();
    // TODO: save token to Firestore /users/{uid}/fcmToken

    FirebaseMessaging.onMessage.listen((msg) {
      // TODO: show in-app notification banner
    });

    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      // TODO: Get.toNamed(msg.data['route'])
    });
  }
}
