import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Map<String, dynamic>> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=gb&category=sports&apiKey=3cba5fc4b71e42d497f667b3b8c75a41'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['articles'] is List &&
            data['articles'].isNotEmpty) {
          final tempArticles = data['articles'];
          setState(() {
            articles = List<Map<String, dynamic>>.from(tempArticles);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _refreshData() async {
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: const Text(
          'News',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.grey.shade700,
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return NewsItem(
              article: article,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final Map<String, dynamic> article;
  final index;
  const NewsItem({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context) {
    final int indexToShow = (index + 1);
    DateTime publishedDateTime = DateTime.parse(article['publishedAt'] ?? '');
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(publishedDateTime);
    // Use the 'article' data here to display individual news items
    return Card(
      color: Colors.grey.shade700,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF333333),),
              child: Text(
                indexToShow.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              article['title'] ?? '',
              style: TextStyle(color: Colors.white, fontSize: 15),
              softWrap: true,
            )),
          ],
        ),
        subtitle: Row(
          children: [
            SizedBox(
              width: 45,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Published at: $formattedDate',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  'Source: ${article['source']['name'] ?? ''}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  'Author: ${article['author'] ?? ''}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        onTap: () async {
          String url = article['url'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: url),
            ),
          );
        },
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;
  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}