import 'package:flutter/material.dart';

import 'package:instagram/core/theme/app_theme.dart';

// ─── Data Models ──────────────────────────────────────────────────────────────

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

enum IGBottomSheet { share, more, addPost }

// ─── BottomSheetUtil ──────────────────────────────────────────────────────────

class BottomSheetUtil {
  BottomSheetUtil._();

  static Future<T?> show<T>(
    BuildContext context, {
    required IGBottomSheet type,

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
