import 'package:firebase_messaging/firebase_messaging.dart';

//3rd fcm service
class FcmService {
  static void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
    });
  }
}
