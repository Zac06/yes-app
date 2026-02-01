import 'package:flutter/material.dart';
import '../dt/post.dart';
import 'screens/article_page.dart';
import '../params/appcolors.dart';
import '../params/appfonts.dart';

class FullArticleTile extends StatelessWidget {
  final Post post;
  const FullArticleTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ArticlePage(post: post)));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              Image.network(
                post.imageUrl!.startsWith('http')
                    ? post.imageUrl!
                    : 'https://live.iiseinaudiscarpa.edu.it/yes-site${post.imageUrl!}',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  );
                },
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: AppFonts.headerFont.copyWith(color: AppColors.text),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${post.authorLine} • '
                    '${post.date.day}/${post.date.month}/${post.date.year}',
                    style: AppFonts.bodyFont.copyWith(color: AppColors.text),
                  ),

                  if (post.categories.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: post.categories
                          .map(
                            (c) => Chip(
                              label: Text(c),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: AppColors.primaryActive,
                                ),
                              ),
                              backgroundColor: AppColors.primaryActive,
                              labelStyle: AppFonts.catFont.copyWith(
                                color: AppColors.onPrimary,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Text(
                    post.excerpt,
                    style: AppFonts.bodyFont.copyWith(color: AppColors.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
