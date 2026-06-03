// ============================================================
//  WHAT GOES HERE
//  Circular avatar used on feed cards, profile headers,
//  comment threads, story rings.
//  Accepts nullable imageUrl; falls back to initial letter.
// ============================================================

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String  fallbackInitial;
  final double  radius;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackInitial,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius:          radius,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child:           imageUrl == null ? Text(fallbackInitial.toUpperCase()) : null,
      );
}
