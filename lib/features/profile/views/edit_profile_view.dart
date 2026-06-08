import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_constants.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/profile/widgets/profile_text_field_widget.dart';
import 'package:instagram/shared_widgets/dropdown_widget.dart';
import 'package:instagram/utils/custom_toast_util.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String slectedGender = '';
  bool hasChanges = false;

  // store initial values
  String initialName = '';
  String initialUsername = '';
  String initialBio = '';
  String initialGender = '';

  @override
  void initState() {
    super.initState();

    // fake initial data (replace with API/Firebase later)
    nameController.text = "John Doe";
    usernameController.text = "john123";
    bioController.text = "Flutter developer";
    slectedGender = "Male";

    initialName = nameController.text;
    initialUsername = usernameController.text;
    initialBio = bioController.text;
    initialGender = slectedGender;
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void checkChanges() {
    final changed =
        nameController.text != initialName ||
        usernameController.text != initialUsername ||
        bioController.text != initialBio ||
        slectedGender != initialGender;

    setState(() {
      hasChanges = changed;
    });
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
            visible: hasChanges,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                CustomToastUtil.showDefault(
                  context,
                  message: 'Profile updated',
                );
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
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: TextButton(onPressed: () {}, child: Text('Edit picture')),
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: nameController,
              onChanged: checkChanges,
              labelText: 'Name',
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: usernameController,
              onChanged: checkChanges,

              labelText: 'Username',
            ),
            SizedBox(height: 10.h),
            ProfileTextFieldWidget(
              controller: bioController,
              onChanged: checkChanges,

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
                  checkChanges();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
