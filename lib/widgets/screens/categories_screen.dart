import 'package:flutter/material.dart';

import 'package:yessite_app/params/appfonts.dart';
import 'package:yessite_app/utils/category_list_assoc.dart';
import 'package:yessite_app/api/yes_api.dart';
import 'package:yessite_app/widgets/screens/category_articles_screen.dart';
import 'package:yessite_app/widgets/category_list_button.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: YESApi.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Errore nel caricamento delle categorie',
                style: AppFonts.bodyFont,
              ),
            );
          }

          final categories = snapshot.data!;
          if (categories.isEmpty) {
            return const Center(
              child: Text('Non ci sono categorie disponibili'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final category = categories[index];

              return SizedBox(
                height: 120, // ← tile height
                child: CategoryListButton(
                  title: category['name'],
                  backgroundImage: AssetImage(
                    CategoryListAssoc.catList[category['id']] ??
                        CategoryListAssoc.catDefault,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryArticlesScreen(
                          categoryId: int.parse(category['id'].toString()),
                          categoryName: category['name'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
