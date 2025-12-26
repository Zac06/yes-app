import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'appfonts.dart';
import 'appcolors.dart';
import 'post.dart';

class ArticlePage extends StatelessWidget {
  final Post post;

  const ArticlePage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: AppFonts.headerFont.copyWith(color: AppColors.text),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(
          data: post.contentHtml,
          style: {
            "body": AppFonts.htmlFromTextStyle(
              AppFonts.bodyFont.copyWith(color: AppColors.text),
            ),
            "img": Style(
              width: Width.auto(),
              margin: Margins.only(bottom: 16),
            ),
            // WordPress caption wrapper
            "figure": Style(
              margin: Margins.only(bottom: 16),
            ),
            // Caption text styling
            "figcaption": Style(
              fontSize: FontSize(14),
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              padding: HtmlPaddings.only(top: 8, bottom: 8),
              textAlign: TextAlign.center,
            ),
            // Alternative caption class that WordPress sometimes uses
            ".wp-caption-text": Style(
              fontSize: FontSize(14),
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              padding: HtmlPaddings.only(top: 8, bottom: 8),
              textAlign: TextAlign.center,
            ),
            // Blockquote styling
            "blockquote": Style(
              fontSize: FontSize(18),
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceBack,
              padding: HtmlPaddings.all(16),
              margin: Margins.symmetric(vertical: 16),
              border: Border(
                left: BorderSide(
                  color: AppColors.primaryActive,
                  width: 4,
                ),
              ),
            ),
            // Heading styles
            "h1": Style(
              fontSize: FontSize(28),
              fontWeight: FontWeight.w900,
              fontFamily: AppFonts.headerFontFamily,
              color: AppColors.primary,
              margin: Margins.only(top: 24, bottom: 12),
            ),
            "h2": Style(
              fontSize: FontSize(24),
              fontWeight: FontWeight.w900,
              fontFamily: AppFonts.headerFontFamily,
              color: AppColors.primary,
              margin: Margins.only(top: 20, bottom: 10),
            ),
            "h3": Style(
              fontSize: FontSize(20),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.headerFontFamily,
              color: AppColors.text,
              margin: Margins.only(top: 16, bottom: 8),
            ),
            "h4": Style(
              fontSize: FontSize(18),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.headerFontFamily,
              color: AppColors.text,
              margin: Margins.only(top: 14, bottom: 8),
            ),
            "h5": Style(
              fontSize: FontSize(16),
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.headerFontFamily,
              color: AppColors.text,
              margin: Margins.only(top: 12, bottom: 6),
            ),
            "h6": Style(
              fontSize: FontSize(14),
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.headerFontFamily,
              color: Colors.grey[700],
              margin: Margins.only(top: 12, bottom: 6),
            ),
            // Horizontal separator
            "hr": Style(
              margin: Margins.symmetric(vertical: 20),
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          },
         
          extensions: [
            TagExtension(
              tagsToExtend: {"img"},
              builder: (extensionContext) {
                final src = extensionContext.attributes['src'];
                if (src == null) return Container();

                // Convert relative URLs to absolute URLs
                final imageUrl = src.startsWith('http')
                    ? src
                    : 'https://live.iiseinaudiscarpa.edu.it/yes-site$src';

                return Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Failed to load image: $imageUrl');
                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}