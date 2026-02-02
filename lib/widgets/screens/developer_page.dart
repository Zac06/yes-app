import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../params/appfonts.dart';
import '../../params/appcolors.dart';
import '../../dt/post.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../dt/github_profile.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  Future<GithubProfile> _obtainInfo() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/zac06'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load GitHub profile');
    }

    return GithubProfile.fromJson(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Informazioni sullo sviluppatore',
            style: AppFonts.headerFont.copyWith(color: AppColors.text),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: FutureBuilder<GithubProfile>(
                    future: _obtainInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final profile = snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(profile.avatarUrl),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            profile.username,
                            style: AppFonts.headerFont.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),

                          Text(
                            profile.name,
                            style: AppFonts.bodyFont.copyWith(
                              fontSize: 18,
                              color: AppColors.text,
                            ),
                          ),

                          const SizedBox(height: 12),

                          GestureDetector(
                            onTap: () async {
                              final url = Uri.parse(profile.profileUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Text(
                              'Profilo GitHub',
                              style: AppFonts.bodyFont.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          if (profile.website.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(profile.website);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Text(
                                'Sito web',
                                style: AppFonts.bodyFont.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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
