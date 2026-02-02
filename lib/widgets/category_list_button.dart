import 'package:flutter/material.dart';

import 'package:yessite_app/params/appfonts.dart';

class CategoryListButton extends StatelessWidget {
  final String title;
  final ImageProvider backgroundImage;
  final VoidCallback? onTap;

  const CategoryListButton({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, // ← THIS WAS MISSING!
          child: Ink(
            decoration: BoxDecoration(
              image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // black overlay
                Container(color: Colors.black.withOpacity(0.35)),
                // centered title
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppFonts.headerFont.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
