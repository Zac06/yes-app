import 'package:flutter/material.dart';
import 'package:yessite_app/appcolors.dart';
import 'package:yessite_app/appfonts.dart';
import 'yes_api.dart';
import 'post.dart';
import 'article_page.dart';
import 'notification_service.dart';
import 'background_task_service.dart';

class AppAssets {
  static const String logo = 'assets/images/titlelogo.png';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  
  // Initialize background tasks
  await BackgroundTaskService.initialize();
  await BackgroundTaskService.registerPeriodicCheck(
    frequency: const Duration(minutes: 15), // Android minimum is 15 minutes
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YES-App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(0x20, 0x2f, 0x5b, 1.0),
        ),
        fontFamily: 'MontSerrat',
        appBarTheme: const AppBarTheme(toolbarHeight: 72, centerTitle: true),
      ),
      home: const AppHomepage(title: 'App'),
    );
  }
}

class AppHomepage extends StatefulWidget {
  const AppHomepage({super.key, required this.title});
  final String title;

  @override
  State<AppHomepage> createState() => _AppHomepageState();
}

class _AppHomepageState extends State<AppHomepage> {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  /// Manual check for new posts (for testing)
  Future<void> _manualCheckForNewPosts() async {
    await NotificationService.manualCheck();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sono stati controllati i nuovi post.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.surfaceBack,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo, height: 32),
              const SizedBox(width: 12),
              Text(
                widget.title,
                style: AppFonts.titleFont.copyWith(color: AppColors.onPrimary),
              ),
            ],
          ),
          /*actions: [
            // Manual check button (for testing)
            IconButton(
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              onPressed: _manualCheckForNewPosts,
              tooltip: 'Aggiorna i nuovi post',
            ),
          ],*/
        ),
        body: RefreshIndicator(
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
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final post = _posts[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArticlePage(post: post),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.imageUrl != null)
                              Image.network(
                                post.imageUrl!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.title,
                                    style: AppFonts.headerFont.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    '${post.authorLine} • '
                                    '${post.date.day}/${post.date.month}/${post.date.year}',
                                    style: AppFonts.bodyFont.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),

                                  if (post.categories.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      children: post.categories
                                          .map(
                                            (c) => Chip(
                                              label: Text(c),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                side: BorderSide(
                                                  color:
                                                      AppColors.primaryActive,
                                                ),
                                              ),
                                              backgroundColor:
                                                  AppColors.primaryActive,
                                              labelStyle: AppFonts.catFont
                                                  .copyWith(
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
                                    style: AppFonts.bodyFont.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}