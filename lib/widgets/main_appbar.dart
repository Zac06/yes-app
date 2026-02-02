import 'package:flutter/material.dart';

import 'package:yessite_app/params/appassets.dart';
import 'package:yessite_app/params/appcolors.dart';
import 'package:yessite_app/params/appfonts.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MainAppbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo, height: 32, width: 32,),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppFonts.titleFont.copyWith(color: AppColors.onPrimary),
              ),
            ],
          ),
          /*actions: [
            // Test button for 1 notification
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: _testOneNotification,
              tooltip: 'Test 1 notifica',
            ),
            // Test button for 2 notifications
            IconButton(
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              onPressed: _testTwoNotifications,
              tooltip: 'Test 2 notifiche',
            ),
          ],*/
        );
  }
}