import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class YESApi {
  static const String _base =
      'https://live.iiseinaudiscarpa.edu.it/yes-site/index.php/wp-json/wp/v2';

  static Future<List<Post>> fetchPosts({
    int page = 1,
    int perPage = 10,
  }) async {
    final uri = Uri.parse(
      '$_base/posts'
      '?_embed'
      '&page=$page'
      '&per_page=$perPage',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts');
    }

    final List data = json.decode(response.body);
    return data.map((e) => Post.fromJson(e)).toList();
  }

  static Future<Post> fetchPostById(int id) async {
  final uri = Uri.parse(
    '$_base/posts/$id?_embed',
  );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Failed to load post $id');
  }

  final data = json.decode(response.body);
  return Post.fromJson(data);
}

}
