import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/data/models/user_model.dart';

// ─── Data Models ──────────────────────────────────────────────────────────────

/// A single comment item passed into [IGBottomSheet.comment].
class IGComment {
  final String user;
  final String text;
  final String time;

  const IGComment({required this.user, required this.text, required this.time});
}

/// A single action item for [IGBottomSheet.more].
class IGMoreAction {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const IGMoreAction({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });
}

/// A single share option for [IGBottomSheet.share].
class IGShareOption {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const IGShareOption({required this.icon, required this.label, this.onTap});
}

/// A single create option for [IGBottomSheet.addPost].
class IGAddPostAction {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;

  const IGAddPostAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
  });
}

// ─── Sheet Type Enum ──────────────────────────────────────────────────────────

enum IGBottomSheet { comment, share, more, addPost }

// ─── BottomSheetUtil ──────────────────────────────────────────────────────────

class BottomSheetUtil {
  BottomSheetUtil._();

  static Future<T?> show<T>(
    BuildContext context, {
    required IGBottomSheet type,

    // ── comment ──────────────────────────────────────────────────────────────
    /// Pre-loaded list of comments to display.
    List<IGComment>? comments,

    /// Called with the new comment text when the user submits a comment.
    void Function(String text)? onCommentSubmit,

    // ── share ─────────────────────────────────────────────────────────────────
    /// Share options to display in the grid.
    List<IGShareOption>? shareOptions,

    // ── more ──────────────────────────────────────────────────────────────────
    /// Action rows shown in the "More" sheet.
    List<IGMoreAction>? moreActions,

    // ── addPost ───────────────────────────────────────────────────────────────
    /// Create-type actions shown in the "Add Post" sheet.
    List<IGAddPostAction>? addPostActions,
  }) {
    final Widget sheet = switch (type) {
      IGBottomSheet.comment => _CommentSheet(
        comments: comments ?? const [],
        onCommentSubmit: onCommentSubmit,
      ),
      IGBottomSheet.share => _ShareSheet(options: shareOptions ?? const []),
      IGBottomSheet.more => _MoreSheet(actions: moreActions ?? const []),
      IGBottomSheet.addPost => _AddPostSheet(
        actions: addPostActions ?? const [],
      ),
    };

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

Widget _dragHandle() => Container(
  width: 36,
  height: 4,
  margin: const EdgeInsets.symmetric(vertical: 10),
  decoration: BoxDecoration(
    color: IGColors.gray,
    borderRadius: BorderRadius.circular(2),
  ),
);

Container _sheetContainer({
  required BuildContext context,
  required Widget child,
  BorderRadius? borderRadius,
}) => Container(
  decoration: BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius:
        borderRadius ?? const BorderRadius.vertical(top: Radius.circular(16)),
  ),
  child: child,
);

// ─── Comment Sheet ────────────────────────────────────────────────────────────

class _CommentSheet extends StatefulWidget {
  /// Initial comments to display (caller-provided).
  final List<IGComment> comments;

  /// Called with the typed text when the user posts a comment.
  /// The caller is responsible for updating state / API.
  final void Function(String text)? onCommentSubmit;

  const _CommentSheet({required this.comments, this.onCommentSubmit});

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _sheetController = DraggableScrollableController();
  late final LocalStorageService _localStorage;
  final _profileUser = Rxn<UserModel>();

  /// Local copy so we can append the optimistic "just now" comment.
  late final List<IGComment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List<IGComment>.from(widget.comments);
    _localStorage = Get.put<LocalStorageService>(LocalStorageService());
    _loadLocalProfile();
    _focusNode.addListener(_onFocusChange);
  }

  Future<void> _loadLocalProfile() async {
    _profileUser.value = _localStorage.getUser();
  }

  void _onFocusChange() {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      _focusNode.hasFocus ? 0.93 : 0.6,
      duration: Duration(milliseconds: _focusNode.hasFocus ? 300 : 250),
      curve: _focusNode.hasFocus ? Curves.easeOut : Curves.easeIn,
    );
  }

  void _postComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Optimistic local update.
    setState(() {
      _comments.add(IGComment(user: 'you', text: text, time: 'Just now'));
      _controller.clear();
    });

    // Notify caller so it can persist / call API.
    widget.onCommentSubmit?.call(text);
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.93,
      expand: false,
      builder: (_, scrollController) {
        return _sheetContainer(
          context: context,
          child: Column(
            children: [
              _dragHandle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Comments',
                  style: ts.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Divider(color: IGColors.gray, thickness: 0.3, height: 0),

              // Comment list.
              Expanded(
                child: _comments.isEmpty
                    ? Center(
                        child: Text(
                          'No comments yet.\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style: ts.bodySmall!.copyWith(fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _comments.length,
                        itemBuilder: (_, i) {
                          final c = _comments[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: IGColors.gray,
                                  backgroundImage: const NetworkImage(
                                    'https://picsum.photos/seed/av/200',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${c.user} ',
                                              style: ts.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            TextSpan(
                                              text: c.text,
                                              style: ts.bodyMedium!.copyWith(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.time,
                                        style: ts.bodySmall!.copyWith(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
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

              // Input row.
              Divider(color: IGColors.gray, thickness: 0.3, height: 0),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, bottomInset + 12),
                child: Row(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        backgroundImage: NetworkImage(
                          _profileUser.value?.profileImageUrl ?? '',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => _postComment(),
                        decoration: InputDecoration(
                          hintText: 'Add a comment…',
                          hintStyle: ts.bodySmall!.copyWith(fontSize: 13.sp),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: IGColors.gray),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(color: IGColors.gray),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          suffixIcon: ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (_, value, __) => value.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.send_rounded),
                                    onPressed: _postComment,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _focusNode.hasFocus,
                child: SizedBox(height: 15.h),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Share Sheet ──────────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final List<IGShareOption> options;

  const _ShareSheet({required this.options});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return _sheetContainer(
      context: context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dragHandle(),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No share options available.'),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final opt = options[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      opt.onTap?.call();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: IGColors.gray.withValues(
                            alpha: 0.35,
                          ),
                          child: Icon(
                            opt.icon,
                            size: 22,
                            color: IGColors.bgDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt.label,
                          style: ts.bodySmall!.copyWith(fontSize: 11),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ─── More Sheet ───────────────────────────────────────────────────────────────

class _MoreSheet extends StatelessWidget {
  final List<IGMoreAction> actions;

  const _MoreSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return _sheetContainer(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragHandle(),
          ...actions.map(
            (a) => ListTile(
              leading: Icon(
                a.icon,
                color: a.color ?? IGColors.bgDark,
                size: 22,
              ),
              title: Text(
                a.label,
                style: ts.bodyMedium!.copyWith(
                  color: a.color ?? IGColors.bgDark,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                a.onTap?.call();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Add Post Sheet ───────────────────────────────────────────────────────────

class _AddPostSheet extends StatelessWidget {
  final List<IGAddPostAction> actions;

  const _AddPostSheet({required this.actions});

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    return _sheetContainer(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragHandle(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Create',
              style: ts.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Divider(color: IGColors.gray, thickness: 0.3, height: 0),
          ...actions.map(
            (a) => ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: IGColors.gray.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(a.icon, size: 22, color: IGColors.bgDark),
              ),
              title: Text(
                a.label,
                style: ts.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                a.subtitle,
                style: ts.bodySmall!.copyWith(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                a.onTap?.call();
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}

// ─── Usage Example ────────────────────────────────────────────────────────────
//
// ── Comment Sheet ─────────────────────────────────────────────────────────────
//
// BottomSheetUtil.show(
//   context,
//   type: IGBottomSheet.comment,
//   comments: [
//     IGComment(user: 'alex.doe', text: 'Amazing shot! 🔥', time: '2h'),
//     IGComment(user: 'sara_m',   text: 'Love this ❤️',     time: '1h'),
//   ],
//   onCommentSubmit: (text) {
//     postController.addComment(postId, text); // your API call
//   },
// );
//
// ── More Sheet ────────────────────────────────────────────────────────────────
//
// BottomSheetUtil.show(
//   context,
//   type: IGBottomSheet.more,
//   moreActions: [
//     IGMoreAction(
//       icon: AppIcons.flag,
//       label: 'Report',
//       color: IGColors.like,
//       onTap: () => postController.report(postId),
//     ),
//     IGMoreAction(
//       icon: AppIcons.hidePost,
//       label: 'Hide post',
//       onTap: () => postController.hide(postId),
//     ),
//     IGMoreAction(
//       icon: AppIcons.personRemove,
//       label: 'Unfollow',
//       onTap: () => userController.unfollow(userId),
//     ),
//     IGMoreAction(
//       icon: AppIcons.copy,
//       label: 'Copy link',
//       onTap: () => Clipboard.setData(ClipboardData(text: postUrl)),
//     ),
//   ],
// );
//
// ── Share Sheet ───────────────────────────────────────────────────────────────
//
// BottomSheetUtil.show(
//   context,
//   type: IGBottomSheet.share,
//   shareOptions: [
//     IGShareOption(icon: Icons.send_outlined,    label: 'Send in DM',
//         onTap: () => shareController.sendDM(postUrl)),
//     IGShareOption(icon: Icons.add_circle_outline, label: 'Add to Story',
//         onTap: () => shareController.addToStory(postUrl)),
//     IGShareOption(icon: Icons.link,             label: 'Copy link',
//         onTap: () => Clipboard.setData(ClipboardData(text: postUrl))),
//     IGShareOption(icon: Icons.bookmark_border,  label: 'Save post',
//         onTap: () => postController.save(postId)),
//   ],
// );
//
// ── Add Post Sheet ────────────────────────────────────────────────────────────
//
// BottomSheetUtil.show(
//   context,
//   type: IGBottomSheet.addPost,
//   addPostActions: [
//     IGAddPostAction(icon: AppIcons.post,   label: 'Post',  subtitle: 'Share a photo',
//         onTap: () => Get.to(() => const CreatePostPage())),
//     IGAddPostAction(icon: AppIcons.reels,  label: 'Reel',  subtitle: 'Share a short video',
//         onTap: () => Get.to(() => const CreateReelPage())),
//     IGAddPostAction(icon: AppIcons.stories,label: 'Story', subtitle: 'Share a photo or video',
//         onTap: () => Get.to(() => const CreateStoryPage())),
//     IGAddPostAction(icon: AppIcons.live,   label: 'Live',  subtitle: 'Go live right now',
//         onTap: () => Get.to(() => const GoLivePage())),
//   ],
// );
