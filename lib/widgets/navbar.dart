import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 70,

      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          //highlightColor: Colors.transparent
          
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,

          onTap: onTap,
          selectedItemColor: AppColors.onPrimary,
          unselectedItemColor: AppColors.onPrimaryInactive,
          backgroundColor: AppColors.primary,
          selectedLabelStyle: AppFonts.navbarFont.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppFonts.navbarFont,

          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded),
              label: 'Articoli',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              label: 'Categorie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Autori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert),
              label: 'Altro',
            ),
          ],
        ),
      ),
    );
  }
}
