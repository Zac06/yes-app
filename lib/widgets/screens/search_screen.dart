import 'package:flutter/material.dart';
import 'package:yessite_app/params/appcolors.dart';
import 'package:yessite_app/params/appfonts.dart';
import '../../api/yes_api.dart';
import '../../dt/post.dart';
import '../reduced_article_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Post> results = [];
  bool loading = false;
  bool loadingMore = false;
  String currentQuery = '';
  int currentPage = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when 200px from bottom
      if (!loadingMore && !loading && hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    setState(() {
      loading = true;
      currentQuery = query;
      currentPage = 1;
      results = [];
      hasMore = true;
    });

    try {
      final newResults = await YESApi.searchPosts(query, page: 1);
      setState(() {
        results = newResults;
        hasMore = newResults.isNotEmpty;
      });
    } catch (e) {
      // Stop searching on error
      setState(() {
        hasMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore nella ricerca: $e')));
      }
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (currentQuery.isEmpty) return;

    setState(() => loadingMore = true);

    try {
      currentPage++;
      final newResults = await YESApi.searchPosts(
        currentQuery,
        page: currentPage,
      );
      setState(() {
        results.addAll(newResults);
        hasMore = newResults.isNotEmpty;
      });
    } catch (e) {
      // Stop loading more on error
      setState(() {
        hasMore = false;
        currentPage--; // Revert page increment
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nessun altro risultato disponibile',
              style: AppFonts.navbarFont.copyWith(color: AppColors.onPrimary),
            ),
          ),
        );
      }
    } finally {
      setState(() => loadingMore = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Cerca qualcosa...',
                prefixIcon: Icon(Icons.search),
                fillColor: AppColors.surfaceBackBack,
                iconColor: AppColors.primary,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: AppColors.surfaceBackBack),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: AppColors.surfaceBackBack),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                filled: true,
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 16),
            if (loading)
              const CircularProgressIndicator(color: AppColors.primary)
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: results.length + (loadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == results.length) {
                      // Loading indicator at bottom
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    }

                    final post = results[index];
                    return ReducedArticleTile(post: post);
                    
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
