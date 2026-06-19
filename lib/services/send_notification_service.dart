import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:instagram/services/google_key_service.dart';

class SendNotificationService {
  /// Core method that actually calls FCM v1 API.
  /// Every notification type below funnels through this.
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    if (token == null || token.isEmpty) {
      print('No device token, skipping notification: $title');
      return;
    }

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

  // ---------------------------------------------------------------------
  // Helper: fetch a user's FCM token from Firestore.
  // Adjust collection/field names ('users' / 'deviceToken') if your
  // UserModel uses different ones (e.g. 'fcmToken').
  // ---------------------------------------------------------------------
  static Future<String?> _getUserToken(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!doc.exists) return null;
      final data = doc.data();
      return data?['deviceToken'] as String?;
    } catch (e) {
      print('Error fetching token for $userId: $e');
      return null;
    }
  }

  // =====================================================================
  // POST: LIKE
  // =====================================================================
  static Future<void> sendLikePostNotification({
    required String postOwnerId,
    required String likerId,
    required String likerUsername,
    required String postId,
    String? postImageUrl,
  }) async {
    if (postOwnerId == likerId) return; // don't notify yourself

    final token = await _getUserToken(postOwnerId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'New Like',
      body: '$likerUsername liked your post',
      data: {
        'type': 'like_post',
        'postId': postId,
        'fromUserId': likerId,
        'fromUsername': likerUsername,
        if (postImageUrl != null) 'postImageUrl': postImageUrl,
      },
    );
  }

  // =====================================================================
  // COMMENT: NEW COMMENT ON POST
  // =====================================================================
  static Future<void> sendCommentNotification({
    required String postOwnerId,
    required String commenterId,
    required String commenterUsername,
    required String postId,
    required String commentText,
  }) async {
    if (postOwnerId == commenterId) return;

    final token = await _getUserToken(postOwnerId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'New Comment',
      body: '$commenterUsername commented: $commentText',
      data: {
        'type': 'comment_post',
        'postId': postId,
        'fromUserId': commenterId,
        'fromUsername': commenterUsername,
      },
    );
  }

  // =====================================================================
  // COMMENT: REPLY TO A COMMENT
  // =====================================================================
  static Future<void> sendCommentReplyNotification({
    required String parentCommenterId,
    required String replierId,
    required String replierUsername,
    required String postId,
    required String commentId,
    required String replyText,
  }) async {
    if (parentCommenterId == replierId) return;

    final token = await _getUserToken(parentCommenterId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'New Reply',
      body: '$replierUsername replied: $replyText',
      data: {
        'type': 'comment_reply',
        'postId': postId,
        'commentId': commentId,
        'fromUserId': replierId,
        'fromUsername': replierUsername,
      },
    );
  }

  // =====================================================================
  // COMMENT: LIKE ON A COMMENT
  // =====================================================================
  static Future<void> sendCommentLikeNotification({
    required String commentOwnerId,
    required String likerId,
    required String likerUsername,
    required String postId,
    required String commentId,
  }) async {
    if (commentOwnerId == likerId) return;

    final token = await _getUserToken(commentOwnerId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'New Like',
      body: '$likerUsername liked your comment',
      data: {
        'type': 'like_comment',
        'postId': postId,
        'commentId': commentId,
        'fromUserId': likerId,
        'fromUsername': likerUsername,
      },
    );
  }

  // =====================================================================
  // FOLLOW: NEW FOLLOWER (public account)
  // =====================================================================
  static Future<void> sendFollowNotification({
    required String followedUserId,
    required String followerId,
    required String followerUsername,
  }) async {
    if (followedUserId == followerId) return;

    final token = await _getUserToken(followedUserId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'New Follower',
      body: '$followerUsername started following you',
      data: {
        'type': 'new_follower',
        'fromUserId': followerId,
        'fromUsername': followerUsername,
      },
    );
  }

  // =====================================================================
  // FOLLOW: FOLLOW REQUEST (private account)
  // =====================================================================
  static Future<void> sendFollowRequestNotification({
    required String targetUserId,
    required String requesterId,
    required String requesterUsername,
  }) async {
    if (targetUserId == requesterId) return;

    final token = await _getUserToken(targetUserId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'Follow Request',
      body: '$requesterUsername wants to follow you',
      data: {
        'type': 'follow_request',
        'fromUserId': requesterId,
        'fromUsername': requesterUsername,
      },
    );
  }

  // =====================================================================
  // FOLLOW: REQUEST ACCEPTED
  // =====================================================================
  static Future<void> sendFollowRequestAcceptedNotification({
    required String requesterId,
    required String accepterId,
    required String accepterUsername,
  }) async {
    if (requesterId == accepterId) return;

    final token = await _getUserToken(requesterId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'Request Accepted',
      body: '$accepterUsername accepted your follow request',
      data: {
        'type': 'follow_request_accepted',
        'fromUserId': accepterId,
        'fromUsername': accepterUsername,
      },
    );
  }

  // =====================================================================
  // MENTION: @username in a comment or caption
  // =====================================================================
  static Future<void> sendMentionNotification({
    required String mentionedUserId,
    required String mentionerId,
    required String mentionerUsername,
    required String postId,
    String location = 'comment', // 'comment' or 'caption'
  }) async {
    if (mentionedUserId == mentionerId) return;

    final token = await _getUserToken(mentionedUserId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'You were mentioned',
      body: '$mentionerUsername mentioned you in a $location',
      data: {
        'type': 'mention',
        'postId': postId,
        'fromUserId': mentionerId,
        'fromUsername': mentionerUsername,
        'location': location,
      },
    );
  }

  // =====================================================================
  // TAG: tagged in a photo/post
  // =====================================================================
  static Future<void> sendTagNotification({
    required String taggedUserId,
    required String taggerId,
    required String taggerUsername,
    required String postId,
  }) async {
    if (taggedUserId == taggerId) return;

    final token = await _getUserToken(taggedUserId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'You were tagged',
      body: '$taggerUsername tagged you in a post',
      data: {
        'type': 'tag_post',
        'postId': postId,
        'fromUserId': taggerId,
        'fromUsername': taggerUsername,
      },
    );
  }

  // =====================================================================
  // DIRECT MESSAGE: new chat message
  // =====================================================================
  static Future<void> sendDirectMessageNotification({
    required String receiverId,
    required String senderId,
    required String senderUsername,
    required String messageText,
    required String chatId,
    bool isImage = false,
  }) async {
    if (receiverId == senderId) return;

    final token = await _getUserToken(receiverId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: senderUsername,
      body: isImage ? 'Sent you a photo' : messageText,
      data: {
        'type': 'direct_message',
        'chatId': chatId,
        'fromUserId': senderId,
        'fromUsername': senderUsername,
      },
    );
  }

  // =====================================================================
  // STORY: LIKE
  // =====================================================================
  static Future<void> sendStoryLikeNotification({
    required String storyOwnerId,
    required String likerId,
    required String likerUsername,
    required String storyId,
  }) async {
    if (storyOwnerId == likerId) return;

    final token = await _getUserToken(storyOwnerId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: 'Story Like',
      body: '$likerUsername liked your story',
      data: {
        'type': 'like_story',
        'storyId': storyId,
        'fromUserId': likerId,
        'fromUsername': likerUsername,
      },
    );
  }

  // =====================================================================
  // STORY: REPLY (treated as a DM in most Instagram clones)
  // =====================================================================
  static Future<void> sendStoryReplyNotification({
    required String storyOwnerId,
    required String replierId,
    required String replierUsername,
    required String storyId,
    required String replyText,
  }) async {
    if (storyOwnerId == replierId) return;

    final token = await _getUserToken(storyOwnerId);
    if (token == null || token.isEmpty) return;

    await sendNotificationUsingApi(
      token: token,
      title: '$replierUsername replied to your story',
      body: replyText,
      data: {
        'type': 'story_reply',
        'storyId': storyId,
        'fromUserId': replierId,
        'fromUsername': replierUsername,
      },
    );
  }
}
