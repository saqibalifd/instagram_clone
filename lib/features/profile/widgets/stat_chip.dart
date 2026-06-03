// ============================================================
//  WHAT GOES HERE
//  Small count + label widget for the profile header row:
//  e.g. "124\nPosts"  "3.2k\nFollowers"  "89\nFollowing"
//  Only used in profile -> stays here.
// ============================================================

import "package:flutter/material.dart";

class StatChip extends StatelessWidget {
  final int    count;
  final String label;
  const StatChip({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text("$count", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label,    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ]);
}
