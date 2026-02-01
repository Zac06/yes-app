import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../params/appcolors.dart';
import '../params/appfonts.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 12),
      
      child: GNav(
        /*color: AppColors.onPrimaryInactive,
        activeColor: AppColors.onPrimary,
        rippleColor: AppColors.primaryRipple,
        tabBackgroundColor: AppColors.primaryRipple,
        backgroundColor: AppColors.primary,*/

        color: AppColors.onPrimaryInactive,
        activeColor: AppColors.primary,
        rippleColor: AppColors.onPrimary,
        tabBackgroundColor: AppColors.surfaceBack,
        backgroundColor: AppColors.primary,

        padding: EdgeInsets.all(14),

        gap: 5,
        onTabChange: onTap,

        tabs: [
          GButton(icon: Icons.article_rounded, text: 'Articoli'),
          GButton(icon: Icons.search_rounded, text: 'Cerca'),
          GButton(icon: Icons.category_rounded, text: 'Categorie'),
          GButton(icon: Icons.more_vert, text: 'Altro'),
        ],
      ),
    ),
    )
    
    ;
  }
}
