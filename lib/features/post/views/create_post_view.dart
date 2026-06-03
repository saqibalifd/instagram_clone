// ============================================================
//  WHAT GOES HERE
//  Compose / create-post screen.
//  * Text field bound to controller.body
//  * Image picker row -> controller.imageUrls
//  * Submit button -> controller.submitPost()
//  * Obx disables button while isSubmitting
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';

class CreatePostView extends GetView<PostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('New Post')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              maxLines: 6,
              onChanged: (v) => controller.body.value = v,
              decoration: const InputDecoration(hintText: "What's on your mind?", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            // TODO: ImagePickerRow widget
            const Spacer(),
            Obx(() => ElevatedButton(
                  onPressed: controller.isSubmitting.value ? null : controller.submitPost,
                  child: const Text('Post'))),
          ]),
        ),
      );
}
