// ============================================================
//  WHAT GOES HERE
//  Horizontal scrolling row: [+ add photo] [thumb] [thumb] ...
//  Uses image_picker package to pick files.
//  Returns selected File paths back to PostController.
//  Only used in the post feature -> stays here.
// ============================================================

import 'package:flutter/material.dart';

class ImagePickerRow extends StatelessWidget {
  final List<String> selectedPaths;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const ImagePickerRow({super.key, required this.selectedPaths, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 72, height: 72,
                margin: const EdgeInsets.only(right: 8),
                color:  Colors.grey[200],
                child:  const Icon(Icons.add_photo_alternate_outlined),
              ),
            ),
            // TODO: map selectedPaths -> thumbnail + remove button
          ],
        ),
      );
}
