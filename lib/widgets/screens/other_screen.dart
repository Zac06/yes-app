import 'package:flutter/material.dart';
import 'package:yessite_app/params/appfonts.dart';
import 'package:yessite_app/utils/category_list_assoc.dart';
import 'package:yessite_app/widgets/others_tile.dart';
import 'package:yessite_app/widgets/screens/developer_page.dart';
import '../../api/yes_api.dart';
import 'category_articles_screen.dart';
import '../../widgets/category_list_button.dart';
import 'categories_screen.dart';
import '../../params/appcolors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'version_page.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: ListView(
        children: [
          OthersTile(
            title: 'Vai al sito',
            icon: Icon(Icons.link_rounded, color: AppColors.text),
            onTap: () {
              _launchUrl("https://live.iiseinaudiscarpa.edu.it/yes-site");
            },
          ),
          OthersTile(
            title: 'Vai al sorgente',
            icon: Icon(Icons.code_rounded, color: AppColors.text),
            onTap: () {
              _launchUrl("https://github.com/zac06/yes-app");
            },
          ),
          OthersTile(
            title: 'Versione',
            icon: Icon(Icons.chevron_right_rounded, color: AppColors.text),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VersionPage(),
                ),
              );
            },
          ),
          OthersTile(
            title: 'Informazioni sullo sviluppatore',
            icon: Icon(Icons.chevron_right_rounded, color: AppColors.text),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeveloperPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
