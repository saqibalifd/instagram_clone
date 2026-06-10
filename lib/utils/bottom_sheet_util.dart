import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:instagram/core/constants/app_icons.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/data/local/local_storage_service.dart';
import 'package:instagram/data/models/user_model.dart';

enum IGBottomSheet { comment, share, more, addPost }

class BottomSheetUtil {
  BottomSheetUtil._();

  static Future<T?> show<T>(
    BuildContext context, {
    required IGBottomSheet type,
    // comment
    String? postOwner,
    int? totalComments,
    // share
    String? postUrl,
    // more
    VoidCallback? onReport,
    VoidCallback? onHide,
    VoidCallback? onUnfollow,
    // addPost
    VoidCallback? onPostPhoto,
    VoidCallback? onPostVideo,
    VoidCallback? onPostReel,
    VoidCallback? onPostStory,
    VoidCallback? onGoLive,
  }) {
    final Widget sheet = switch (type) {
      IGBottomSheet.comment => _CommentSheet(
        postOwner: postOwner ?? '',
        totalComments: totalComments ?? 0,
      ),
      IGBottomSheet.share => _ShareSheet(postUrl: postUrl),
      IGBottomSheet.more => _MoreSheet(
        onReport: onReport,
        onHide: onHide,
        onUnfollow: onUnfollow,
      ),
      IGBottomSheet.addPost => _AddPostSheet(
        onPostPhoto: onPostPhoto,
        onPostVideo: onPostVideo,
        onPostReel: onPostReel,
        onPostStory: onPostStory,
        onGoLive: onGoLive,
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

// ─── Shared drag handle ───────────────────────────────────────────────────────

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
  final String postOwner;
  final int totalComments;

  const _CommentSheet({required this.postOwner, required this.totalComments});

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode(); // single focus node, used everywhere
  final _sheetController =
      DraggableScrollableController(); // ← controls sheet size
  late final LocalStorageService _localStorage;
  final profileUser = Rxn<UserModel>();

  final List<Map<String, String>> _comments = [
    {'user': 'alex.doe', 'text': 'Amazing shot! 🔥', 'time': '2h'},
    {'user': 'sara_m', 'text': 'Love this so much ❤️', 'time': '1h'},
    {'user': 'john_travels', 'text': 'Where is this place?', 'time': '45m'},
    {'user': 'alex.doe', 'text': 'Amazing shot! 🔥', 'time': '2h'},
    {'user': 'sara_m', 'text': 'Love this so much ❤️', 'time': '1h'},
    {'user': 'john_travels', 'text': 'Where is this place?', 'time': '45m'},
    {'user': 'alex.doe', 'text': 'Amazing shot! 🔥', 'time': '2h'},
  ];

  @override
  void initState() {
    super.initState();
    _localStorage = Get.put<LocalStorageService>(LocalStorageService());
    loadLocalProfile();

    // ← listen for focus changes and snap the sheet accordingly
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_sheetController.isAttached) return;
    if (_focusNode.hasFocus) {
      // keyboard is opening → expand to full view
      _sheetController.animateTo(
        0.93,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // keyboard dismissed → return to half view
      _sheetController.animateTo(
        0.6,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> loadLocalProfile() async {
    final user = _localStorage.getUser();
    profileUser.value = user;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange); // ← always remove before dispose
    _focusNode.dispose();
    _sheetController.dispose(); // ← dispose the sheet controller too
    super.dispose();
  }

  void _postComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add({'user': 'you', 'text': text, 'time': 'Just now'});
      _controller.clear();
    });
    _focusNode.unfocus(); // this triggers _onFocusChange → sheet shrinks back
  }

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      controller: _sheetController, // ← attach controller
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

              // ← Expanded fills all remaining space; no more fixed Container height
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
                                              text: '${c['user']} ',
                                              style: ts.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            TextSpan(
                                              text: c['text'],
                                              style: ts.bodyMedium!.copyWith(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c['time']!,
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

              Divider(color: IGColors.gray, thickness: 0.3, height: 0),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, bottomInset + 12),
                child: Row(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        backgroundImage: NetworkImage(
                          profileUser.value?.profileImageUrl ?? '',
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
                        onTap: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          setState(() {});
                        },

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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _focusNode.hasFocus,
                child: SizedBox(height: 300.h),
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
  final String? postUrl;

  const _ShareSheet({this.postUrl});

  static const _options = [
    (icon: Icons.send_outlined, label: 'Send in DM'),
    (icon: Icons.add_circle_outline, label: 'Add to Story'),
    (icon: Icons.link, label: 'Copy link'),
    (icon: Icons.bookmark_border, label: 'Save post'),
  ];

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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: _options.length,
              itemBuilder: (_, i) {
                final opt = _options[i];
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: IGColors.gray.withValues(alpha: 0.35),
                        child: Icon(opt.icon, size: 22, color: IGColors.bgDark),
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
  final VoidCallback? onReport;
  final VoidCallback? onHide;
  final VoidCallback? onUnfollow;
  final VoidCallback? onCopyLink;

  const _MoreSheet({
    this.onReport,
    this.onHide,
    this.onUnfollow,
    this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    final actions = [
      (
        icon: AppIcons.flag,
        label: 'Report',
        color: IGColors.like,
        cb: onReport,
      ),
      (
        icon: AppIcons.hidePost,
        label: 'Hide post',
        color: IGColors.bgDark,
        cb: onHide,
      ),
      (
        icon: AppIcons.personRemove,
        label: 'Unfollow',
        color: IGColors.bgDark,
        cb: onUnfollow,
      ),
      (
        icon: AppIcons.copy,
        label: 'Copy link',
        color: IGColors.bgDark,
        cb: onCopyLink,
      ),
    ];

    return _sheetContainer(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dragHandle(),
          ...actions.map(
            (a) => ListTile(
              leading: Icon(a.icon, color: a.color, size: 22),
              title: Text(
                a.label,
                style: ts.bodyMedium!.copyWith(color: a.color, fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                a.cb?.call();
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
  final VoidCallback? onPostPhoto;
  final VoidCallback? onPostVideo;
  final VoidCallback? onPostReel;
  final VoidCallback? onPostStory;
  final VoidCallback? onGoLive;

  const _AddPostSheet({
    this.onPostPhoto,
    this.onPostVideo,
    this.onPostReel,
    this.onPostStory,
    this.onGoLive,
  });

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;

    final actions = [
      (
        icon: AppIcons.post, // e.g. Icons.image_outlined
        label: 'Post',
        subtitle: 'Share a photo',
        cb: onPostPhoto,
      ),
      (
        icon: AppIcons.reels, // e.g. Icons.video_camera_back_outlined
        label: 'Reel',
        subtitle: 'Share a short video',
        cb: onPostReel,
      ),
      (
        icon: AppIcons.stories, // e.g. Icons.circle_outlined
        label: 'Story',
        subtitle: 'Share a photo or video',
        cb: onPostStory,
      ),
      (
        icon: AppIcons.live, // e.g. Icons.live_tv_outlined
        label: 'Live',
        subtitle: 'Go live right now',
        cb: onGoLive,
      ),
    ];

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
                a.cb?.call();
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }
}
