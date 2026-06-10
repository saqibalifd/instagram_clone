import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/routes/app_routes.dart';
import 'package:instagram/utils/bottom_sheet_util.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PageController pageController = PageController();
  bool isLiked = false;
  bool isFollow = false;

  final List<Map<String, dynamic>> reels = [
    {
      "username": "john_doe",
      "caption": "Enjoying the beautiful sunset 🌅",
      "likes": "125K",
      "comments": "2.3K",
      "shares": "8.5K",
      "isFollowing": false,
    },
    {
      "username": "flutter_dev",
      "caption": "Building Instagram Clone in Flutter 🚀",
      "likes": "98K",
      "comments": "1.1K",
      "shares": "4.2K",
      "isFollowing": false,
    },
    {
      "username": "travel_world",
      "caption": "Exploring new places ✈️",
      "likes": "210K",
      "comments": "6.4K",
      "shares": "15K",
      "isFollowing": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              /// Video Placeholder
              Container(
                color: Colors.grey.shade900,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white54,
                    size: 80,
                  ),
                ),
              ),

              /// Bottom Content
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Left Side
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.publicProfile,
                                    arguments: 'cc8J8XNLKLRlyXPr8jGPLN7RMqr2',
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d29tYW4lMjBwcm9maWxlfGVufDB8fDB8fHww',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                reel["username"],
                                style: const TextStyle(
                                  color: IGColors.bgLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 30.h,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      isFollow = !isFollow;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: IGColors.bgLight,
                                    ),
                                  ),
                                  child: Text(
                                    isFollow ? "Following" : "Follow",
                                    style: TextStyle(color: IGColors.bgLight),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            reel["caption"],
                            style: const TextStyle(color: IGColors.bgLight),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// Right Side Actions
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: Icon(
                            AppIcons.heartFill,
                            color: isLiked ? IGColors.like : IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["likes"],
                          style: TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            BottomSheetUtil.show(
                              context,
                              type: IGBottomSheet.comment,
                            );
                          },
                          child: Icon(
                            AppIcons.messageFill,
                            color: IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["comments"],
                          style: const TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        InkWell(
                          onTap: () {
                            BottomSheetUtil.show(
                              context,
                              type: IGBottomSheet.share,
                            );
                          },
                          child: Icon(
                            AppIcons.send,
                            color: IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          reel["shares"],
                          style: const TextStyle(color: IGColors.bgLight),
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            BottomSheetUtil.show(
                              context,
                              type: IGBottomSheet.more,
                            );
                          },

                          child: Icon(
                            AppIcons.more,
                            color: IGColors.bgLight,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
