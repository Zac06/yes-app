import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yessite_app/appfonts.dart';
import 'appcolors.dart';

class VersionCheckService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/zac06/yes-app/releases/latest';

  /// Check for new version on GitHub
  static Future<GitHubRelease?> checkForUpdate() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Fetch latest release from GitHub
      final response = await http.get(Uri.parse(_githubApiUrl));

      if (response.statusCode != 200) {
        print('Failed to fetch GitHub release: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body);
      final latestVersion = (data['tag_name'] as String).replaceFirst('v', '');
      final downloadUrl = data['html_url'] as String;
      final releaseNotes = data['body'] as String? ?? '';

      // Compare versions
      if (_isNewerVersion(currentVersion, latestVersion)) {
        return GitHubRelease(
          version: latestVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
        );
      }

      return null;
    } catch (e) {
      print('Error checking for updates: $e');
      return null;
    }
  }

  /// Compare two version strings (e.g., "1.0.0" vs "1.0.1")
  static bool _isNewerVersion(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }

    return false;
  }

  /// Show update dialog
  static void showUpdateDialog(BuildContext context, GitHubRelease release) {
    showDialog(
      context: context,
      barrierDismissible: false,
      
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Nuova versione disponibile', style: AppFonts.headerFont),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versione ${release.version} è ora disponibile!',
              style: AppFonts.bodyFont,
            ),
            const SizedBox(height: 16),
            if (release.releaseNotes.isNotEmpty) ...[
              const Text(
                'Note di rilascio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                release.releaseNotes,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppFonts.bodyFont,
            ),
            child: const Text('Ignora'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final uri = Uri.parse(release.downloadUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              textStyle: AppFonts.bodyFont,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Scarica la nuova versione'),
          ),
        ],
      ),
    );
  }
}

class GitHubRelease {
  final String version;
  final String downloadUrl;
  final String releaseNotes;

  GitHubRelease({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
  });
}
