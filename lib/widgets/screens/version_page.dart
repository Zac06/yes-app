import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../params/appfonts.dart';
import '../../params/appcolors.dart';
import '../../dt/post.dart';

import 'package:package_info_plus/package_info_plus.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  Future<PackageInfo> _obtainInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Versione app',
            style: AppFonts.headerFont.copyWith(color: AppColors.text),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: FutureBuilder<PackageInfo>(
                    future: _obtainInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final info = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'YES-App',
                            style: AppFonts.catFont,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Versione: ${info.version}',
                            style: AppFonts.bodyFont.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Numero di build: ${info.buildNumber}',
                            style: AppFonts.bodyFont.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Nome pacchetto: ${info.packageName}',
                            style: AppFonts.bodyFont.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
