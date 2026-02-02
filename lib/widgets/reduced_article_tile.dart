import 'package:flutter/material.dart';

import 'package:yessite_app/dt/post.dart';
import 'screens/article_page.dart';
import 'package:yessite_app/params/appcolors.dart';
import 'package:yessite_app/params/appfonts.dart';

class ReducedArticleTile extends StatelessWidget {
  final Post post;
  const ReducedArticleTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ArticlePage(post: post)));
      },
      child: Card(
        color: AppColors.surfaceTop,
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: AppFonts.searchTitleFont.copyWith(
                      color: AppColors.text,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    post.excerpt,
                    style: AppFonts.bodyFont.copyWith(color: AppColors.text),

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
