import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/user_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/features/profile/widgets/profile_text_field_widget.dart';
import 'package:instagram/shared_widgets/dropdown_widget.dart';
import 'package:instagram/utils/image_picker_util.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final ProfileController _profileController = Get.put(ProfileController());

  File? image;

  Future<void> _pickAny() async {
    final file = await ImagePickerUtil.pick(
      context,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file != null) setState(() => image = file);
  }

  late UserModel user;
  String slectedGender = '';
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    user = Get.arguments as UserModel;
    nameController.text = user.fullName;
    usernameController.text = user.username;
    bioController.text = user.bio;
    slectedGender = user.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text('Edit profile', style: ts.displayMedium),
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () async {
                await _profileController.updateProfile(
                  context,
                  nameController.text,
                  bioController.text,
                  slectedGender,
                );
                if (image != null) {
                  await _profileController.updateProfilePicture(
                    context,
                    image!,
                  );
                }
                await _profileController.loadLocalProfile();
                Get.back();
              },
              icon: Icon(AppIcons.check, color: IGColors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalSmallPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: CircleAvatar(
                radius: 40.r,
                backgroundImage: image == null
                    ? NetworkImage(user.profileImageUrl)
                    : FileImage(image ?? File(user.profileImageUrl)),

                // backgroundImage: NetworkImage(user.profileImageUrl),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),

                onPressed: () {
                  _pickAny();
                },
                child: Text('Edit picture'),
              ),
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: nameController,
              labelText: 'Name',
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: usernameController,
              readOnly: true,
              labelText: 'Username',
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: bioController,

              labelText: 'Bio',
              maxLines: 3,
            ),
            SizedBox(height: 10.h),
            DropdownWidget(
              label: 'Gender',

              value: slectedGender,
              items: ['Female', 'Male'],
              onChanged: (value) {
                setState(() {
                  slectedGender = value;
                  // checkChanges();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
