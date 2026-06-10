import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/core/theme/app_theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final List<Map<String, String>> dummyNotifications = [
    {
      "name": "John",
      "title": "liked your post",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "image": "https://picsum.photos/seed/11/300",
      "time": "3m ago",
    },
    {
      "name": "Sarah",
      "title": "commented on your photo",
      "avatar": "https://i.pravatar.cc/150?img=2",
      "image": "https://picsum.photos/seed/12/300",
      "time": "4d ago",
    },
    {
      "name": "Ali",
      "title": "started following you",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "image": '',
      "time": "9h ago",
    },
    {
      "name": "Emma",
      "title": "mentioned you in a comment",
      "avatar": "https://i.pravatar.cc/150?img=4",
      "image": "https://picsum.photos/seed/14/300",
      "time": "2h ago",
    },
    {
      "name": "David",
      "title": "liked your reel",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "image": "https://picsum.photos/seed/15/300",
      "time": "1w ago",
    },
    {
      "name": "John",
      "title": "liked your post",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "image": "https://picsum.photos/seed/11/300",
      "time": "3m ago",
    },
    {
      "name": "Sarah",
      "title": "commented on your photo",
      "avatar": "https://i.pravatar.cc/150?img=2",
      "image": "https://picsum.photos/seed/12/300",
      "time": "4d ago",
    },
    {
      "name": "Ali",
      "title": "started following you",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "image": '',
      "time": "9h ago",
    },
    {
      "name": "Emma",
      "title": "mentioned you in a comment",
      "avatar": "https://i.pravatar.cc/150?img=4",
      "image": "https://picsum.photos/seed/14/300",
      "time": "2h ago",
    },
    {
      "name": "David",
      "title": "liked your reel",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "image": "https://picsum.photos/seed/15/300",
      "time": "1w ago",
    },
    {
      "name": "John",
      "title": "liked your post",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "image": "https://picsum.photos/seed/11/300",
      "time": "3m ago",
    },
    {
      "name": "Sarah",
      "title": "commented on your photo",
      "avatar": "https://i.pravatar.cc/150?img=2",
      "image": "https://picsum.photos/seed/12/300",
      "time": "4d ago",
    },
    {
      "name": "Ali",
      "title": "started following you",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "image": '',
      "time": "9h ago",
    },
    {
      "name": "Emma",
      "title": "mentioned you in a comment",
      "avatar": "https://i.pravatar.cc/150?img=4",
      "image": "https://picsum.photos/seed/14/300",
      "time": "2h ago",
    },
    {
      "name": "David",
      "title": "liked your reel",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "image": "https://picsum.photos/seed/15/300",
      "time": "1w ago",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text('Notifications', style: ts.displayMedium),
      ),

      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  dummyNotifications[index]['avatar']!,
                ),
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${dummyNotifications[index]['name']} ",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "${dummyNotifications[index]['title']}. ",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: dummyNotifications[index]['time'],
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
                  (dummyNotifications[index]['image'] != null &&
                      dummyNotifications[index]['image']!.isNotEmpty)
                  ? SizedBox(
                      height: 80,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          dummyNotifications[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
