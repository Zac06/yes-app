import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:yessite_app/dt/post.dart';

class YESApi {
  static const String _base =
      'https://live.iiseinaudiscarpa.edu.it/yes-site/index.php/wp-json/wp/v2';

  static Future<List<Post>> fetchPosts({
    int page = 1,
    int perPage = 10,
    int? categoryId,
  }) async {
    final queryParams = <String, String>{
      '_embed': '',
      'page': page.toString(),
      'per_page': perPage.toString(),
    };

    if (categoryId != null) {
      queryParams['categories'] = categoryId.toString();
    }

    final uri = Uri.parse('$_base/posts').replace(queryParameters: queryParams);

    final response = await http.get(uri);


    if (response.statusCode != 200) {
      throw Exception('Failed to load posts');
    }

    final List data = json.decode(response.body);
    return data.map((e) => Post.fromJson(e)).toList();
  }

  static Future<Post> fetchPostById(int id) async {
    final uri = Uri.parse('$_base/posts/$id?_embed');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load post $id');
    }

    final data = json.decode(response.body);
    return Post.fromJson(data);
  }

  static Future<List<Post>> searchPosts(String q, {int page = 1}) async {
    final uri = Uri.parse(
      '$_base/posts'
      '?_embed'
      '&search=${Uri.encodeQueryComponent(q)}'
      '&page=$page',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search posts');
    }

    final List data = json.decode(response.body);
    return data.map((e) => Post.fromJson(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchCategories({
    int page = 1,
    int perPage = 100,
  }) async {
    final uri = Uri.parse(
      '$_base/categories'
      '?page=$page'
      '&per_page=$perPage'
      '&hide_empty=true',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  }
}
