import 'package:flutter/material.dart';
import '../../api/yes_api.dart';
import '../../dt/post.dart';
import '../semi_article_tile.dart';
import '../../params/appcolors.dart';
import '../../params/appfonts.dart';

class CategoryArticlesScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryArticlesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryArticlesScreen> createState() => _CategoryArticlesScreenState();
}

class _CategoryArticlesScreenState extends State<CategoryArticlesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Post> _posts = [];
  int _currentPage = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }
    if (!_hasMore) return;

    setState(() {
      _loading = _posts.isEmpty && !refresh;
      _loadingMore = _posts.isNotEmpty && !refresh;
    });

    try {
      final newPosts = await YESApi.fetchPosts(
        page: _currentPage,
        categoryId: widget.categoryId, // 👈 important
      );

      setState(() {
        if (refresh) {
          _posts = newPosts;
        } else {
          _posts.addAll(newPosts);
        }
        _hasMore = newPosts.isNotEmpty;
        _loading = false;
        _loadingMore = false;
      });

      _currentPage++;
    } catch (e) {
      setState(() {
        _loading = false;
        _loadingMore = false;
      });
      debugPrint('Errore caricamento articoli categoria: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_loadingMore &&
        _hasMore) {
      _loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBack,
      appBar: AppBar(
        title: Text(widget.categoryName, style: AppFonts.headerFont),
        backgroundColor: AppColors.surfaceBack,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadPosts(refresh: true),
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _posts.length + (_loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _posts.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  final post = _posts[index];
                  return SemiArticleTile(post: post);
                },
              ),
      ),
    );
  }
}
