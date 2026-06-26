import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:instagram/controllers/location_controller.dart';
import 'package:instagram/controllers/posts_controller.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/utils/image_picker_util.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  final PostsController postsController = Get.put(PostsController());
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController captionController = TextEditingController();

  File? selectedImage;
  bool isUploading = false;
  final TextEditingController tagsController = TextEditingController();

  Future<void> pickImage() async {
    final file = await ImagePickerUtil.pick(
      context,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file != null) setState(() => selectedImage = file);
  }

  String visibility = 'public';
  bool allowComments = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
    tagsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text("Create Post"),
        actions: [
          TextButton(
            onPressed: () async {
              if (selectedImage != null) {
                await postsController.uploadPost(
                  context,
                  selectedImage!,
                  captionController.text,
                  locationController.selectedLocation.value,
                  visibility,
                  allowComments,
                  tagsController,
                );
                Get.back();
              }
            },
            child: Text("Share", style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 350.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: IGColors.gray.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 60.sp,
                            color: IGColors.gray,
                          ),
                          SizedBox(height: 8.h),
                          const Text(
                            "Select Photo",
                            style: TextStyle(color: IGColors.gray),
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(height: 20.h),

            TextField(
              controller: captionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write a caption...",
                filled: true,
                fillColor: IGColors.gray.withValues(alpha: .2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Card(
              elevation: 0,
              color: IGColors.gray.withValues(alpha: .2),
              child: Column(
                children: [
                  Obx(
                    () => ListTile(
                      onTap: () {
                        locationController.getCurrentLocation(context);
                      },
                      leading: Icon(AppIcons.location),
                      title: Text(
                        locationController.selectedLocation.value.isEmpty
                            ? "Add Location"
                            : locationController.selectedLocation.value,
                      ),
                      trailing: locationController.isLoadingLocation.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(AppIcons.arrowNext),
                    ),
                  ),
                  Divider(thickness: 1),
                  // Allow Comments
                  SwitchListTile(
                    value: allowComments,
                    onChanged: (value) {
                      setState(() {
                        allowComments = value;
                      });
                    },
                    secondary: Icon(AppIcons.comment),
                    title: const Text("Allow Comments"),
                  ),

                  const Divider(thickness: 1),

                  // Visibility
                  ListTile(
                    leading: Icon(AppIcons.global),
                    title: Text("Visibility"),
                    trailing: DropdownButton<String>(
                      value: visibility,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'public',
                          child: Text('Public'),
                        ),
                        DropdownMenuItem(
                          value: 'followers',
                          child: Text('Followers'),
                        ),
                        DropdownMenuItem(
                          value: 'private',
                          child: Text('Private'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            visibility = value;
                          });
                        }
                      },
                    ),
                  ),

                  const Divider(thickness: 1),

                  // Tags
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextField(
                      controller: tagsController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(AppIcons.tags),
                        hintText: "Tags (e.g. john, alex, sara)",
                        helperText: "Separate tags with commas",
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
