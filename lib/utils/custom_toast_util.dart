import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';

/// Instagram-style Toast & Snackbar Utility
/// Supports: default, link copied, success, error, like notification,
/// action button, gradient (brand), long message, and bottom placement variants.
class CustomToastUtil {
  CustomToastUtil._(); // prevent instantiation

  static const LinearGradient _instagramGradient = IGColors.buttonGradient;

  // ─── Shared helpers ────────────────────────────────────────────────────────

  /// Base method – all public variants eventually call this.
  static void _show(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
    Color backgroundColor = const Color(0xFF3A3A3A),
    double elevation = 0,
    ShapeBorder? shape,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: content,
          duration: duration,
          behavior: behavior,
          margin:
              margin ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape:
              shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.zero, // content handles its own padding
        ),
      );
  }

  // ─── 1. DEFAULT ────────────────────────────────────────────────────────────
  /// Simple text toast (e.g. "Post has been archived.")
  static void showDefault(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      duration: duration,
      content: _DefaultContent(message: message),
    );
  }

  // ─── 2. LINK COPIED ───────────────────────────────────────────────────────
  /// Toast with a chain-link icon (e.g. "Link copied to clipboard.")
  static void showLinkCopied(
    BuildContext context, {
    String message = 'Link copied to clipboard.',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      duration: duration,
      content: _IconContent(icon: Icons.link_rounded, message: message),
    );
  }

  // ─── 3. SUCCESS ───────────────────────────────────────────────────────────
  /// Toast with a green check-circle (e.g. "Your changes have been saved.")
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      duration: duration,
      content: _IconContent(
        icon: Icons.check_circle_outline_rounded,
        iconColor: IGColors.green,
        message: message,
      ),
    );
  }

  // ─── 4. ERROR ─────────────────────────────────────────────────────────────
  /// Toast with a red error-circle (e.g. "Couldn't send message. Try again.")
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      duration: duration,
      content: _IconContent(
        icon: Icons.cancel_outlined,
        iconColor: IGColors.like,
        message: message,
      ),
    );
  }

  // ─── 5. LIKE NOTIFICATION ─────────────────────────────────────────────────
  /// Toast with a heart icon (e.g. "Added to your liked posts.")
  static void showLikeNotification(
    BuildContext context, {
    String message = 'Added to your liked posts.',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      duration: duration,
      content: _IconContent(
        icon: Icons.favorite_border_rounded,
        iconColor: IGColors.like,
        message: message,
      ),
    );
  }

  // ─── 6. WITH ACTION BUTTON ────────────────────────────────────────────────
  /// Toast with a pink action label on the right.
  /// [actionLabel] defaults to "Undo". Pass "Retry" or any custom label.
  static void showWithAction(
    BuildContext context, {
    required String message,
    String actionLabel = 'Undo',
    IconData? leadingIcon,
    Color? leadingIconColor,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      duration: duration,
      content: _ActionContent(
        message: message,
        actionLabel: actionLabel,
        leadingIcon: leadingIcon,
        leadingIconColor: leadingIconColor,
        onAction: onAction,
      ),
    );
  }

  // ─── 7. GRADIENT – BRAND ─────────────────────────────────────────────────
  /// Full-width gradient toast with Instagram branding.
  static void showGradient(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: _GradientContent(
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        gradient: _instagramGradient,
      ),
    );
  }

  // ─── 8. LONG MESSAGE ─────────────────────────────────────────────────────
  /// Multi-line toast (wraps text naturally).
  static void showLongMessage(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      duration: duration,
      content: _LongMessageContent(message: message),
    );
  }

  // ─── 9. BOTTOM PLACEMENT ─────────────────────────────────────────────────
  /// Toast anchored just above the bottom nav bar (fixed behaviour).
  static void showAtBottom(
    BuildContext context, {
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: icon != null
              ? _IconContent(icon: icon, message: message)
              : _DefaultContent(message: message),
          duration: duration,
          behavior: SnackBarBehavior.fixed, // sticks to bottom
          backgroundColor: const Color(0xFF3A3A3A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        ),
      );
  }
}

// ─── Private content widgets ──────────────────────────────────────────────────

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        message,
        style: const TextStyle(
          color: IGColors.cardLight,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _IconContent extends StatelessWidget {
  const _IconContent({
    required this.icon,
    required this.message,
    this.iconColor = IGColors.bgLight,
  });

  final IconData icon;
  final String message;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: IGColors.bgLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionContent extends StatelessWidget {
  const _ActionContent({
    required this.message,
    required this.actionLabel,
    this.leadingIcon,
    this.leadingIconColor,
    this.onAction,
  });

  final String message;
  final String actionLabel;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(
              leadingIcon,
              color: leadingIconColor ?? IGColors.bgLight,
              size: 22,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: IGColors.bgLight,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              onAction?.call();
            },
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: IGColors.like,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientContent extends StatelessWidget {
  const _GradientContent({
    required this.message,
    required this.gradient,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final Gradient gradient;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: IGColors.bgLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: IGColors.bgLight,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: IGColors.bgLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onAction?.call();
              },
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: IGColors.bgLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LongMessageContent extends StatelessWidget {
  const _LongMessageContent({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        message,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: IGColors.bgLight,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
      ),
    );
  }
}

// class ToastDemoScreen extends StatelessWidget {
//   const ToastDemoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF121212),
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Instagram',
//                 style: TextStyle(
//                   color: Color(0xFFE1306C),
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               TextSpan(
//                 text: '  Toasts & Snackbars',
//                 style: TextStyle(
//                   color: Colors.white54,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         children: [
//           _SectionLabel('DEFAULT'),
//           _DemoButton(
//             label: 'Post has been archived.',
//             onTap: () => CustomToastUtil.showDefault(
//               context,
//               message: 'Post has been archived.',
//             ),
//           ),
//           _SectionLabel('LINK COPIED'),
//           _DemoButton(
//             label: 'Link copied to clipboard.',
//             onTap: () => CustomToastUtil.showLinkCopied(context),
//           ),
//           _SectionLabel('SUCCESS'),
//           _DemoButton(
//             label: 'Your changes have been saved.',
//             onTap: () => CustomToastUtil.showSuccess(
//               context,
//               message: 'Your changes have been saved.',
//             ),
//           ),
//           _SectionLabel('ERROR'),
//           _DemoButton(
//             label: "Couldn't send message. Try again.",
//             onTap: () => CustomToastUtil.showError(
//               context,
//               message: "Couldn't send message. Try again.",
//             ),
//           ),
//           _SectionLabel('LIKE NOTIFICATION'),
//           _DemoButton(
//             label: 'Added to your liked posts.',
//             onTap: () => CustomToastUtil.showLikeNotification(context),
//           ),
//           _SectionLabel('WITH ACTION BUTTON – Undo'),
//           _DemoButton(
//             label: 'Post deleted.  →  Undo',
//             onTap: () => CustomToastUtil.showWithAction(
//               context,
//               message: 'Post deleted.',
//               actionLabel: 'Undo',
//               onAction: () => debugPrint('Undo tapped'),
//             ),
//           ),
//           _SectionLabel('WITH ACTION BUTTON – Retry'),
//           _DemoButton(
//             label: 'Upload failed.  →  Retry',
//             onTap: () => CustomToastUtil.showWithAction(
//               context,
//               message: 'Upload failed.',
//               actionLabel: 'Retry',
//               leadingIcon: Icons.cancel_outlined,
//               leadingIconColor: const Color(0xFFED4956),
//               onAction: () => debugPrint('Retry tapped'),
//             ),
//           ),
//           _SectionLabel('GRADIENT (BRAND) – No action'),
//           _DemoButton(
//             label: 'Welcome back to Instagram.',
//             onTap: () => CustomToastUtil.showGradient(
//               context,
//               message: 'Welcome back to Instagram.',
//             ),
//           ),
//           _SectionLabel('GRADIENT (BRAND) – With View'),
//           _DemoButton(
//             label: 'Your story is now live!  →  View',
//             onTap: () => CustomToastUtil.showGradient(
//               context,
//               message: 'Your story is now live!',
//               actionLabel: 'View',
//               onAction: () => debugPrint('View tapped'),
//             ),
//           ),
//           _SectionLabel('LONG MESSAGE'),
//           _DemoButton(
//             label:
//                 'You can only add music to stories\nshared to your followers.',
//             onTap: () => CustomToastUtil.showLongMessage(
//               context,
//               message:
//                   'You can only add music to stories shared to your followers.',
//             ),
//           ),
//           _SectionLabel('PLACEMENT PREVIEW (BOTTOM)'),
//           _DemoButton(
//             label: 'Link copied.  (fixed bottom)',
//             onTap: () => CustomToastUtil.showAtBottom(
//               context,
//               message: 'Link copied.',
//               icon: Icons.link_rounded,
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
// }

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: IGColors.bgLight, fontSize: 14),
        ),
      ),
    );
  }
}
