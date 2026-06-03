// ============================================================
//  WHAT GOES HERE
//  Post card used by BOTH feed and profile grids.
//  Stateless — receives PostModel + optional callbacks.
//  Promote a widget to shared_widgets only when ≥2 features use it.
// ============================================================

import 'package:flutter/material.dart';
import '../data/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel    post;
  final VoidCallback? onLike;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onLike, this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:  ListTile(
          title:    Text(post.body),
          subtitle: Text('${post.likesCount} likes'),
          trailing: IconButton(icon: const Icon(Icons.favorite_border), onPressed: onLike),
          onTap:    onTap,
        ),
      );
}
