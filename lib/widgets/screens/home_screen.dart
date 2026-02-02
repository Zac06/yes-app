import 'package:flutter/material.dart';

import 'package:yessite_app/widgets/full_article_tile.dart';
import 'package:yessite_app/dt/post.dart';
import 'package:yessite_app/api/yes_api.dart';
import 'package:yessite_app/services/notification_service.dart';
import 'package:yessite_app/services/version_check_service.dart';
import 'package:yessite_app/params/appcolors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    _initializeLastPostId();
    _checkForUpdates();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Check for app updates on GitHub
  Future<void> _checkForUpdates() async {
    // Wait a bit for the UI to load
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final release = await VersionCheckService.checkForUpdate();
    if (release != null && mounted) {
      VersionCheckService.showUpdateDialog(context, release);
    }
  }

  /// Initialize last post ID on first app launch
  Future<void> _initializeLastPostId() async {
    final lastId = await NotificationService.getLastPostId();
    if (lastId == null && _posts.isNotEmpty) {
      await NotificationService.saveLastPostId(_posts.first.id);
    }
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
      final newPosts = await YESApi.fetchPosts(page: _currentPage);
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

      // Update last seen post ID when refreshing
      if (refresh && _posts.isNotEmpty) {
        await NotificationService.saveLastPostId(_posts.first.id);
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _loadingMore = false;
      });
      debugPrint('Errore durante il reperimento dei post: $e');
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

  /// Test notification with one article
  Future<void> _testOneNotification() async {
    if (_posts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nessun articolo disponibile')),
      );
      return;
    }

    await NotificationService.testNotificationOne(_posts);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('1 notifica di test inviata')));
  }

  /// Test notification with two articles
  Future<void> _testTwoNotifications() async {
    if (_posts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nessun articolo disponibile')),
      );
      return;
    }

    await NotificationService.testNotificationTwo(_posts);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_posts.length > 1 ? "2" : "1"} notifica/e di test inviate',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadPosts(refresh: true),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length + (_loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                }
                final post = _posts[index];
                return FullArticleTile(post: post);
              },
            ),
    );
  }
}
