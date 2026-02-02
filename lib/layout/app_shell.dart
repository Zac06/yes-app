import 'package:flutter/material.dart';
import 'package:yessite_app/widgets/screens/other_screen.dart';
import '../widgets/navbar.dart';
import '../widgets/main_appbar.dart';
import '../params/appcolors.dart';
import '../widgets/screens/home_screen.dart';
import '../widgets/screens/search_screen.dart';
import '../widgets/screens/categories_screen.dart';
import '../widgets/screens/other_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.title});
  final String title;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  
  static int currentIndex=0;
  List<Widget> screens=const [
    HomeScreen(),
    SearchScreen(),
    CategoriesScreen(),
    OtherScreen()
  ];

  void onTap(int index){
    setState(() {
      currentIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavbar(currentIndex: currentIndex, onTap: onTap),
        backgroundColor: AppColors.surfaceBack,
        appBar: MainAppbar(title: widget.title),
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        //body: screens[currentIndex],
      ),
    );
  }
}
