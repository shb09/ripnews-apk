import 'package:flutter/material.dart';
import 'package:newsly/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsly/detail_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  List<dynamic> Articles = [];
  bool isLoading = false;
  String error = '';

  Future<void> LoadArticles(String query) async {
    setState(() {
      isLoading = true;
      error = ''; // Clear previous errors
    });

    final url =
        'https://newsapi.org/v2/everything?q=$query&apiKey=b677b5097965477789753d46e8432683';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          Articles = data['articles'];
          isLoading = false;
        });

        if (Articles.isEmpty) {
          setState(() {
            error = 'No results found for "$query".';
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error: Unable to fetch articles. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("RIP NEWS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 2),
            Text("Search",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        leading: const Icon(Icons.article_rounded),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_2_outlined),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onEditingComplete: () {
                if (controller.text.isNotEmpty) {
                  LoadArticles(controller.text);
                }
              },
            ),
            const Divider(
              height: 3,
            ),
            if (error.isNotEmpty)
              Center(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.black),
                ),
              )
            else if (Articles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: Articles.length,
                  itemBuilder: (context, index) {
                    final article = Articles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        title: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                article['urlToImage'] ??
                                    'https://media.istockphoto.com/vectors/no-image-available-sign-vector-id1138179183?k=6&m=1138179183&s=612x612&w=0&h=prMYPP9mLRNpTp3XIykjeJJ8oCZRhb2iez6vKs8a8eE=',
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article['source']['name'] ?? " ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                article['title'] ?? " ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article['author'] ?? ' '),
                                Text(article['publishedAt'] ?? ' ')
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(article: article),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
