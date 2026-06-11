import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/dm/widgets/dm_my_stories_circle_widget.dart';
import 'package:instagram/features/dm/widgets/dm_stories_circle_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/image_picker_util.dart';

class DmView extends StatefulWidget {
  const DmView({super.key});

  @override
  State<DmView> createState() => _DmViewState();
}

class _DmViewState extends State<DmView> {
  final storiesUsers = [
    {
      'name': 'Ali',
      'profileImage': 'https://i.pravatar.cc/150?img=1',
      'storyImage':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      'songTitle': 'Blinding Lights • The Weeknd',
      'timeAgo': '5m ago',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Iftikhar Ali',
      'profileImage': 'https://i.pravatar.cc/150?img=2',
      'storyImage':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
      'songTitle': 'Calm Down • Rema',
      'timeAgo': '15m ago',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Jamshed Hussain Alvi',
      'profileImage': 'https://i.pravatar.cc/150?img=3',
      'storyImage':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
      'songTitle': 'Perfect • Ed Sheeran',
      'timeAgo': '30m ago',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Fakhar Hussain',
      'profileImage': 'https://i.pravatar.cc/150?img=4',
      'storyImage':
          'https://images.unsplash.com/photo-1494526585095-c41746248156?w=800',
      'songTitle': 'Starboy • The Weeknd',
      'timeAgo': '1h ago',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Hassan Ali',
      'profileImage': 'https://i.pravatar.cc/150?img=5',
      'storyImage':
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
      'songTitle': 'Shape of You • Ed Sheeran',
      'timeAgo': '2h ago',
      'isPlayed': true,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Usman Khan',
      'profileImage': 'https://i.pravatar.cc/150?img=6',
      'storyImage':
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
      'songTitle': 'Until I Found You • Stephen Sanchez',
      'timeAgo': '3h ago',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
  ];

  final List<Map<String, String>> users = [
    {
      'name': 'Elsa',
      'status': 'Active 16 min ago.',
      'image':
          'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&auto=format&fit=crop',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'John',
      'status': 'Active now',
      'image':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'Sophia',
      'status': 'Active 5 min ago.',
      'image':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'Michael',
      'status': 'Active 1 hour ago.',
      'image':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'Emma',
      'status': 'Active yesterday',
      'image':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'David',
      'status': 'Online',
      'image':
          'https://images.unsplash.com/photo-1504593811423-6dd665756598?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'Olivia',
      'status': 'Active 30 min ago.',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
    {
      'name': 'James',
      'status': 'Active 2 hours ago.',
      'image':
          'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=500',
      "userId": "cc8J8XNLKLRlyXPr8jGPLN7RMqr2",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('saqibali.fd', style: ts.displayMedium),
        // actions: [IconButton(onPressed: () {}, icon: Icon(AppIcons.editNote))],
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalSmallPadding,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(AppIcons.search),
                  fillColor: IGColors.gray.withValues(alpha: .2),
                  filled: true,
                  hintText: 'Search with Meta AI',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 110.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storiesUsers.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: DmMyStoriesCircleWidget(
                        imageUrl:
                            'https://img.magnific.com/free-psd/modern-dynamic-banner_125755-403.jpg?semt=ais_hybrid&w=740&q=80',
                        onStoryTap: () {
                          Get.toNamed(
                            AppRoutes.viewStory,
                            arguments: {
                              'name': 'Saqib Ali',
                              'profileImage':
                                  'https://media.easy-peasy.ai/4e600a82-8aac-4abb-95cd-f87cc9125a0f/18ea5802-d34e-4fbb-91e2-99baebb2eac9_medium.webp',
                              'storyImage':
                                  'https://img.magnific.com/free-psd/modern-dynamic-banner_125755-403.jpg?semt=ais_hybrid&w=740&q=80',
                              'songTitle': 'Smells Like Teen Spirit',
                              'timeAgo': '5 min ago',
                            },
                          );
                        },
                        onAddStory: () async {
                          // print('add story');
                          await ImagePickerUtil.pickFromGallery(
                            context,
                            maxWidth: 1024,
                            imageQuality: 85,
                          );
                        },
                      ),
                    );
                  }

                  final storyIndex = index - 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: DmStoriesCircleWidget(
                      onStoryTap: () {
                        Get.toNamed(
                          AppRoutes.viewStory,
                          arguments: {
                            'name': storiesUsers[storyIndex]['name'],
                            'profileImage':
                                storiesUsers[storyIndex]['profileImage'],
                            'storyImage':
                                storiesUsers[storyIndex]['storyImage'],
                            'songTitle': storiesUsers[storyIndex]['songTitle'],
                            'timeAgo': storiesUsers[storyIndex]['timeAgo'],
                          },
                        );
                      },
                      imageUrl: storiesUsers[storyIndex]['storyImage']
                          .toString(),
                      name:
                          storiesUsers[storyIndex]['name'].toString().length >
                              10
                          ? '${storiesUsers[storyIndex]['name'].toString().substring(0, 10)}...'
                          : storiesUsers[storyIndex]['name'].toString(),
                      isPlayed: storiesUsers[storyIndex]['isPlayed'] as bool,
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalSmallPadding,
                  vertical: 8,
                ),
                child: Text('Messages', style: ts.displaySmall),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final user = users[index];

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.chat,
                          arguments: {
                            'name': user['name'],
                            'status': user['status'],
                            'image': user['image'],
                            'userId': user['userId'],
                          },
                        );
                      },
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user['image']!),
                          ),
                          Visibility(
                            visible:
                                user['status'] == 'Online' ||
                                    user['status'] == 'Active now'
                                ? true
                                : false,
                            child: Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: IGColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(user['name']!),
                      subtitle: Text(user['status']!),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
