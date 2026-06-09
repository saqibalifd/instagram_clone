import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/features/home/widgets/my_storie_circle_widget.dart';
import 'package:instagram/features/home/widgets/posts_card_widget.dart';
import 'package:instagram/features/home/widgets/stories_circle_widget.dart';
import 'package:instagram/features/home/widgets/suggested_card_widget.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';
import 'package:instagram/utils/image_picker_util.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? image;

  final storiesUsers = [
    {
      'name': 'Ali',
      'image': 'https://i.pravatar.cc/150?img=1',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Iftikha Ali',
      'image': 'https://i.pravatar.cc/150?img=2',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Jamshed hussain alvi',
      'image': 'https://i.pravatar.cc/150?img=3',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Fakhar hussain',
      'image': 'https://i.pravatar.cc/150?img=10',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Hassan Ali',
      'image': 'https://i.pravatar.cc/150?img=7',
      'isPlayed': true,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
    {
      'name': 'Iftikha Ali',
      'image': 'https://i.pravatar.cc/150?img=2',
      'isPlayed': false,
      'userId': 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
    },
  ];

  final suggestedPosts = [
    {
      'name': 'Ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=1',
      'mutualFriends': 5,
    },
    {
      'name': 'Nadeem ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=4',
      'mutualFriends': 5,
    },
    {
      'name': 'Iftikhar ali',
      'imageUrl': 'https://i.pravatar.cc/150?img=8',
      'mutualFriends': 5,
    },
  ];

  final postImages = [
    'https://i.pravatar.cc/600?img=11',
    'https://i.pravatar.cc/600?img=12',
    'https://i.pravatar.cc/600?img=13',
    'https://i.pravatar.cc/600?img=14',
    'https://i.pravatar.cc/600?img=15',
    'https://i.pravatar.cc/600?img=16',
    'https://i.pravatar.cc/600?img=17',
    'https://i.pravatar.cc/600?img=18',
    'https://i.pravatar.cc/600?img=19',
    'https://i.pravatar.cc/600?img=20',
  ];

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            BottomSheetUtil.show(
              context,
              type: IGBottomSheet.addPost,
              onPostPhoto: () {
                Get.toNamed(AppRoutes.addPost, arguments: 'photo');
              },
            );
          },
          icon: Icon(AppIcons.add),
        ),
        title: Text(
          'Instagram',
          style: GoogleFonts.grandHotel(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Get.toNamed(AppRoutes.notification);
            },
            icon: Icon(AppIcons.heart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stories Row ──────────────────────────────────────
            SizedBox(
              height: 110.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storiesUsers.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: MyStorieCircleWidget(
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
                    child: StoriesCircleWidget(
                      imageUrl: storiesUsers[storyIndex]['image'].toString(),
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'Suggested for you',
                style: ts.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),

            SizedBox(
              height: 240.h,
              child: ListView.builder(
                itemCount: suggestedPosts.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder: (context, index) {
                  return SuggestedCardWidget(
                    onFollow: () {
                      print('Follow');
                    },
                    name: suggestedPosts[index]['name'].toString(),

                    image: suggestedPosts[index]['imageUrl'].toString(),

                    totalMutual: suggestedPosts[index]['mutualFriends'] as int,
                  );
                },
              ),
            ),

            SizedBox(height: 8.h),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: postImages.length,
              itemBuilder: (context, index) {
                final user = storiesUsers[index % storiesUsers.length];
                return PostsCardWidget(
                  image: user['image'].toString(),
                  name: user['name'].toString(),
                  location: 'Lahore, Pakistan',
                  postImage: postImages[index],
                  likes: 234,
                  caption: 'Sharing a beautiful moment 🌟',
                  totalComments: 233,
                  timeAgo: '2 HOURS AGO',
                  userId: user['userId'].toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
