import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram/services/google_key_service.dart';

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKeySevice().getServerKeyToken();

    String url =
        'https://fcm.googleapis.com/v1/projects/instagram-a799a/messages:send';
    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data,
      },
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Notification not sent');
      print('Response body: ${response.body}');
    }
  }

  // static Future<void> sendNotificationToClass({
  //   required String classId,
  //   required String title,
  //   required String body,
  //   required Map<String, dynamic> data,
  //   String? excludeUserId,
  // }) async {
  //   try {
  //     final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('classId', isEqualTo: classId)
  //         .get();

  //     if (snapshot.docs.isEmpty) {
  //       print('No users found for classId: $classId');
  //       return;
  //     }

  //     final List<UserModel> matchedUsers = snapshot.docs
  //         .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();

  //     for (UserModel user in matchedUsers) {
  //       if (excludeUserId != null && user.userId == excludeUserId) continue;
  //       if (user.deviceToken.isEmpty) continue;

  //       await sendNotificationUsingApi(
  //         token: user.deviceToken,
  //         title: title,
  //         body: body,
  //         data: data,
  //       );

  //       print('Notification sent to: ${user.name} (${user.role})');
  //     }

  //     print('All notifications sent for classId: $classId');
  //   } catch (e) {
  //     print('Error sending notifications to class: $e');
  //   }
  // }

  // static Future<void> sendNotificationToStudents({
  //   required String classId,
  //   required String title,
  //   required String body,
  //   required Map<String, dynamic> data,
  //   String? excludeUserId,
  // }) async {
  //   try {
  //     final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('classId', isEqualTo: classId)
  //         .where('role', isEqualTo: 'Student')
  //         // .where('userId', isNotEqualTo: excludeUserId)
  //         .get();

  //     if (snapshot.docs.isEmpty) {
  //       print('No students found for classId: $classId');
  //       return;
  //     }

  //     for (var doc in snapshot.docs) {
  //       final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

  //       if (excludeUserId != null && user.userId == excludeUserId) continue;
  //       if (user.deviceToken.isEmpty) continue;

  //       await sendNotificationUsingApi(
  //         token: user.deviceToken,
  //         title: title,
  //         body: body,
  //         data: data,
  //       );

  //       print('Notification sent to student: ${user.name}');
  //     }
  //   } catch (e) {
  //     print('Error sending notifications to students: $e');
  //   }
  // }

  // static Future<void> sendNotificationToTeacher({
  //   required String classId,
  //   required String title,
  //   required String body,
  //   required Map<String, dynamic> data,
  // }) async {
  //   try {
  //     final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('classId', isEqualTo: classId)
  //         .where('role', isEqualTo: 'Teacher')
  //         .get();

  //     if (snapshot.docs.isEmpty) {
  //       print('No teacher found for classId: $classId');
  //       return;
  //     }

  //     for (var doc in snapshot.docs) {
  //       final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

  //       if (user.deviceToken.isEmpty) continue;

  //       await sendNotificationUsingApi(
  //         token: user.deviceToken,
  //         title: title,
  //         body: body,
  //         data: data,
  //       );

  //       print(
  //         'Notification sent to teacher on this token: ${user.deviceToken}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error sending notification to teacher: $e');
  //   }
  // }
}
