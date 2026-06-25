import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/models/comments_model.dart';
import 'package:instagram/features/profile/controllers/profile_controller.dart';
import 'package:instagram/utils/chached_images_manager.dart';

class CustomCommentBottomSheetUtil {
  static Future<void> show(
    BuildContext context, {
    List<CommentModel> comments = const [],
    Function(String)? onCommentSubmit,
    String? userImage,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentSheet(
        comments: comments,
        onCommentSubmit: onCommentSubmit,
        userImage: userImage,
      ),
    );
  }
}

class _CommentSheet extends StatefulWidget {
  final List<CommentModel> comments;
  final Function(String)? onCommentSubmit;
  final String? userImage;

  const _CommentSheet({
    required this.comments,
    this.onCommentSubmit,
    this.userImage,
  });

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final TextEditingController _controller = TextEditingController();

  String getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _postComment() {
    print('hehehehehhhhheeeeeeeeeeeeeeeeeeeeeee');
    print('Button clicked');
    print(_controller.text);

    // widget.onCommentSubmit?.call(_controller.text);
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    widget.onCommentSubmit?.call(text);
    _controller.clear();
  }

  final ProfileController profileController = Get.put(ProfileController());
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Comments',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: widget.comments.isEmpty
                ? const Center(
                    child: Text(
                      'No comments yet.\nBe the first to comment!',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      final comment = widget.comments[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.r),
                                child: CachedImageManager.image(
                                  url: comment.profilePicture,
                                  fit: BoxFit.cover,
                                  errorWidget: CircleAvatar(
                                    backgroundColor: IGColors.gray.withValues(
                                      alpha: .3,
                                    ),
                                    child: Icon(
                                      AppIcons.profile,
                                      color: IGColors.bgLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: '${comment.username} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: comment.text),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Text(
                                        getTimeAgo(comment.createdAt),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),

                                      if (comment.likesCount > 0) ...[
                                        const SizedBox(width: 12),
                                        Text(
                                          '${comment.likesCount} likes',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],

                                      if (comment.isEdited) ...[
                                        const SizedBox(width: 12),
                                        Text(
                                          'edited',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const Divider(height: 1),

          Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, bottomInset + 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.r),
                    child: CachedImageManager.image(
                      url: profileController.profileUser.value!.profileImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: CircleAvatar(
                        backgroundColor: IGColors.gray.withValues(alpha: .3),
                        child: Icon(AppIcons.profile, color: IGColors.bgLight),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _postComment(),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(AppIcons.send),
                        // onPressed: _postComment,
                        onPressed: _postComment,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
