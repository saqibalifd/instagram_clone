import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';

class ViewStoryView extends StatefulWidget {
  const ViewStoryView({super.key});

  @override
  State<ViewStoryView> createState() => _ViewStoryViewState();
}

class _ViewStoryViewState extends State<ViewStoryView> {
  bool isFollowing = false;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(Duration(seconds: 7), () => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    final String name = args['name'] ?? '';
    final String profileImage = args['profileImage'] ?? '';
    final String storyImage = args['storyImage'] ?? '';
    final String songTitle = args['songTitle'] ?? '';

    return Scaffold(
      backgroundColor: IGColors.bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Image.network(storyImage, fit: BoxFit.cover),
              ),
            ),

            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.publicProfile,
                    arguments: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                ),
              ),
              title: Text(name, style: TextStyle(color: IGColors.bgLight)),
              subtitle: Row(
                children: [
                  Icon(
                    AppIcons.music,
                    size: 14,
                    color: IGColors.bgLight.withValues(alpha: .6),
                  ),
                  SizedBox(width: 5.w),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      songTitle,
                      style: TextStyle(
                        color: IGColors.bgLight.withValues(alpha: .6),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: SizedBox(
                height: 30.h,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                  },
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(color: IGColors.bgLight),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: IGColors.bgLight),

                      decoration: InputDecoration(
                        hintText: 'Send message',
                        filled: true,
                        fillColor: Colors.transparent,
                        hintStyle: const TextStyle(color: IGColors.bgLight),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: IGColors.bgLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: IGColors.bgLight),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: Icon(
                      isLiked ? AppIcons.heartFill : AppIcons.heart,
                      color: isLiked ? IGColors.like : IGColors.bgLight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(AppIcons.dm, color: IGColors.bgLight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
