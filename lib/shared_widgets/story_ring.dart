// ============================================================
//  WHAT GOES HERE
//  Gradient ring around an avatar indicating an unread story.
//  Used in the feed header AND on profile — so it lives here.
//  hasUnread toggles the gradient ring on/off.
// ============================================================

import 'package:flutter/material.dart';
import 'user_avatar.dart';

class StoryRing extends StatelessWidget {
  final String? imageUrl;
  final String  initial;
  final bool    hasUnread;

  const StoryRing({super.key, this.imageUrl, required this.initial, this.hasUnread = false});

  @override
  Widget build(BuildContext context) => Container(
        padding:    const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape:    BoxShape.circle,
          gradient: hasUnread
              ? const LinearGradient(colors: [Colors.orange, Colors.purple])
              : null,
          color: hasUnread ? null : Colors.grey[300],
        ),
        child: UserAvatar(imageUrl: imageUrl, fallbackInitial: initial, radius: 24),
      );
}
