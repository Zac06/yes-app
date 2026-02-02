import 'package:flutter/material.dart';

import 'package:yessite_app/params/appcolors.dart';
import 'package:yessite_app/params/appfonts.dart';

class OthersTile extends StatelessWidget {
  final String title;
  final Icon? icon;
  final VoidCallback? onTap;

  const OthersTile({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Material(
          color: AppColors.surfaceTop, // change if you want
          borderRadius: BorderRadius.circular(14),
          elevation: 2,
          child: InkWell(
            splashColor: AppColors.text.withOpacity(0.1),
            highlightColor: AppColors.text.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppFonts.navbarFont.copyWith(color: AppColors.text, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if(icon!=null) icon!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
