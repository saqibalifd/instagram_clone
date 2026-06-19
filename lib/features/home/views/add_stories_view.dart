import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/controllers/stories_controller.dart';
import 'package:instagram/core/theme/app_theme.dart';

class AddStoriesView extends StatefulWidget {
  const AddStoriesView({super.key});

  @override
  State<AddStoriesView> createState() => _AddStoriesViewState();
}

class _AddStoriesViewState extends State<AddStoriesView> {
  final StoriesController storiesController = Get.put(StoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            CircleAvatar(
              radius: 40.r,
              backgroundColor: IGColors.gray,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        print('add post');
                      },
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: IGColors.bgDark,
                        child: Icon(
                          Icons.add,
                          color: IGColors.bgLight,
                          size: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              decoration: InputDecoration(hintText: 'What\'s on your mind?'),
            ),
            SizedBox(height: 10.h),

            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  storiesController.uploadStories('hello this is stories');
                },
                child: Text('add Stories'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
