// ============================================================
//  WHAT GOES HERE
//  Skeleton loader shown while the first page of posts loads.
//  Only used inside feed -> stays here (not in shared_widgets).
//  TODO: replace grey boxes with shimmer package animation.
// ============================================================

import 'package:flutter/material.dart';

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin:     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height:     120,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        ),
      );
}
