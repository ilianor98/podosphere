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
  String selectedCountry = 'gb';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=$selectedCountry&category=sports&apiKey=3cba5fc4b71e42d497f667b3b8c75a41'),
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
            fontSize: 32,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCountry,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry =
                      newValue ?? 'gb'; // Default to Great Britain if null
                  fetchNews();
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'ar',
                  child: Row(
                    children: [
                      Text(
                        'Argentina',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'au',
                  child: Row(
                    children: [
                      Text(
                        'Australia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'at',
                  child: Row(
                    children: [
                      Text(
                        'Austria',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'be',
                  child: Row(
                    children: [
                      Text(
                        'Belgium',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'br',
                  child: Row(
                    children: [
                      Text(
                        'Brazil',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'bg',
                  child: Row(
                    children: [
                      Text(
                        'Bulgaria',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ca',
                  child: Row(
                    children: [
                      Text(
                        'Canada',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'cn',
                  child: Row(
                    children: [
                      Text(
                        'China',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'co',
                  child: Row(
                    children: [
                      Text(
                        'Colombia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'cu',
                  child: Row(
                    children: [
                      Text(
                        'Cuba',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'cz',
                  child: Row(
                    children: [
                      Text(
                        'Czech Republic',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'eg',
                  child: Row(
                    children: [
                      Text(
                        'Egypt',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'fr',
                  child: Row(
                    children: [
                      Text(
                        'France',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'de',
                  child: Row(
                    children: [
                      Text(
                        'Germany',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'gb',
                  child: Row(
                    children: [
                      Text(
                        'Great Britain',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'gr',
                  child: Row(
                    children: [
                      Text(
                        'Greece',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'hk',
                  child: Row(
                    children: [
                      Text(
                        'Hong Kong',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'hu',
                  child: Row(
                    children: [
                      Text(
                        'Hungary',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'in',
                  child: Row(
                    children: [
                      Text(
                        'India',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'id',
                  child: Row(
                    children: [
                      Text(
                        'Indonesia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ie',
                  child: Row(
                    children: [
                      Text(
                        'Ireland',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'il',
                  child: Row(
                    children: [
                      Text(
                        'Israel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'it',
                  child: Row(
                    children: [
                      Text(
                        'Italy',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'jp',
                  child: Row(
                    children: [
                      Text(
                        'Japan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'lv',
                  child: Row(
                    children: [
                      Text(
                        'Latvia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'lt',
                  child: Row(
                    children: [
                      Text(
                        'Lithuania',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'my',
                  child: Row(
                    children: [
                      Text(
                        'Malaysia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'mx',
                  child: Row(
                    children: [
                      Text(
                        'Mexico',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ma',
                  child: Row(
                    children: [
                      Text(
                        'Morocco',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'nl',
                  child: Row(
                    children: [
                      Text(
                        'Netherlands',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'nz',
                  child: Row(
                    children: [
                      Text(
                        'New Zealand',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ng',
                  child: Row(
                    children: [
                      Text(
                        'Nigeria',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'no',
                  child: Row(
                    children: [
                      Text(
                        'Norway',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ph',
                  child: Row(
                    children: [
                      Text(
                        'Philippines',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'pl',
                  child: Row(
                    children: [
                      Text(
                        'Poland',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'pt',
                  child: Row(
                    children: [
                      Text(
                        'Portugal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ro',
                  child: Row(
                    children: [
                      Text(
                        'Romania',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'ru',
                  child: Row(
                    children: [
                      Text(
                        'Russia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'sa',
                  child: Row(
                    children: [
                      Text(
                        'Saudi Arabia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'rs',
                  child: Row(
                    children: [
                      Text(
                        'Serbia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'sg',
                  child: Row(
                    children: [
                      Text(
                        'Singapore',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'sk',
                  child: Row(
                    children: [
                      Text(
                        'Slovakia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'si',
                  child: Row(
                    children: [
                      Text(
                        'Slovenia',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
              dropdownColor: const Color(0xFF333333),
            ),
          ),
        ],
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF333333),
              ),
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
