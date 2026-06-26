import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class FollowTabView extends StatelessWidget {
  final String tabType; // 'followers', 'following', or 'subscriptions'
  final String userId;

  const FollowTabView({super.key, required this.tabType, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Show static "No subscriptions" UI for subscriptions tab
    if (tabType == 'subscriptions') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.subscriptions_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Subscriptions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'You have no active subscriptions yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Stream the specific user's document to get their followers/following list
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Center(child: Text('User not found.'));
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;

        // Extract the list of user IDs based on tab type
        final List<dynamic> userIds =
            (userData[tabType] as List<dynamic>?) ?? [];

        if (userIds.isEmpty) {
          return Center(
            child: Text(
              tabType == 'followers'
                  ? 'No followers yet.'
                  : 'Not following anyone yet.',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        // Fetch user documents for each ID in the list
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(AppConstants.usersCollection)
              .where(FieldPath.documentId, whereIn: userIds.cast<String>())
              .snapshots(),
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!usersSnapshot.hasData || usersSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No users found.'));
            }

            final users = usersSnapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index].data() as Map<String, dynamic>;

                return ListTile(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.publicProfile,
                      arguments: user['userId'],
                    );
                  },
                  leading: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: CachedImageManager.image(
                        url: user['profileImageUrl'],
                        fit: BoxFit.cover,
                        errorWidget: CircleAvatar(
                          backgroundColor: IGColors.gray.withValues(alpha: .3),
                          child: Icon(
                            AppIcons.profile,
                            color: IGColors.bgLight,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  title: Text(user['fullName'] ?? ''),
                  subtitle: Text(user['username'] ?? ''),
                );
              },
            );
          },
        );
      },
    );
  }
}
