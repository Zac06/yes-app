import 'package:flutter/material.dart';
import '../../api/yes_api.dart';
import '../../dt/post.dart';
import '../article_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Post> results=[];
  bool loading=false;

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    setState(() => loading = true);

    try {
      results = await YESApi.searchPosts(query);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search articles...',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: _search,
          ),

          const SizedBox(height: 16),

          if (loading)
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final post = results[index];
                  return ListTile(
                    title: Text(post.title),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ArticlePage(post: post),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}