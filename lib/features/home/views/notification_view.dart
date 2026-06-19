import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/controllers/notification_controller.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  initState() {
    super.initState();
    notificationController.fetchAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text('Notifications', style: ts.displayMedium),
      ),

      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (notificationController.notificationsList.isEmpty) {
          return const Center(child: Text('No notifications found'));
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: notificationController.notificationsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    notificationController
                        .notificationsList[index]
                        .senderProfileImage,
                  ),
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${notificationController.notificationsList[index].senderName} ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${notificationController.notificationsList[index].title}. ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: notificationController
                            .notificationsList[index]
                            .createdAt
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: IGColors.gray,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing:
                    (notificationController
                                .notificationsList[index]
                                .postImage !=
                            null &&
                        notificationController
                            .notificationsList[index]
                            .postImage
                            .isNotEmpty)
                    ? SizedBox(
                        height: 80,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            notificationController
                                .notificationsList[index]
                                .postImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            );
          },
        );
      }),
    );
  }
}
