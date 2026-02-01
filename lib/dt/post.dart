import 'package:html_unescape/html_unescape.dart';

class Post {
  final int id;
  final String title;
  final String excerpt;

  /// FULL HTML article
  final String contentHtml;

  final List<String> _authors;
  final String authorLine;

  final String? imageUrl;
  final DateTime date;
  final List<String> categories;
  final String link;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.contentHtml,
    required List<String> authors,
    required this.imageUrl,
    required this.date,
    required this.categories,
    required this.link,
  })  : _authors = authors,
        authorLine =
            authors.isEmpty ? 'Unknown author' : authors.join(', ');

  factory Post.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    String stripHtml(String html) =>
        unescape.convert(html.replaceAll(RegExp(r'<[^>]*>'), ''));

    String shorten(String text, int max) =>
        text.length > max ? '${text.substring(0, max)}…' : text;

    String cleanHtml(String html) {
  return html
      .replaceAll(RegExp(r'loading="lazy"'), '')
      .replaceAll(RegExp(r'decoding="async"'), '');
}

    // ----- title -----
    final title = shorten(
      stripHtml(json['title']?['rendered'] ?? ''),
      75,
    );

    // ----- excerpt -----
    final excerpt = shorten(
      stripHtml(json['excerpt']?['rendered'] ?? ''),
      140,
    );

    // ----- FULL CONTENT HTML -----
    final contentHtml =
        cleanHtml(unescape.convert(json['content']?['rendered'] ?? ''));

    // ----- authors -----
    final authors = (json['authors'] as List?)
            ?.map((a) => "${a['first_name']} ${a['last_name']}")
            .toList() ??
        [];

    // ----- featured image -----
    final imageUrl =
        json['_embedded']?['wp:featuredmedia']?[0]?['source_url'];

    // ----- date -----
    final date = DateTime.parse(json['date']);

    // ----- categories -----
    final categories =
        (json['_embedded']?['wp:term']?[0] as List?)
                ?.map((e) => e['name'] as String)
                .toList() ??
            [];

    return Post(
      id: json['id'],
      title: title,
      excerpt: excerpt,
      contentHtml: contentHtml,
      authors: authors,
      imageUrl: imageUrl,
      date: date,
      categories: categories,
      link: json['link'],
    );
  }
}
