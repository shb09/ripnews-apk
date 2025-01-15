import 'package:flutter/material.dart';
import 'package:newsly/profile_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'detail_page.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _homeState();
}

class _homeState extends State<Home> {
  List<dynamic> articles = [];
  String selectedButton = 'Technology';
  bool isLoading = false;

  Future<void> loadArticles(String query) async {
    setState(() {
      isLoading = true; // Set loading state to true when fetching articles
    });

    final url = 'https://newsapi.org/v2/everything?q=$query&apiKey=5e1f4139f7084f878291bbfefc2349c9';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Parse the JSON
        setState(() {
          articles = data['articles']; // Assign articles to the state variable
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors if needed
      print('Error: $e');
    }
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      selectedButton = buttonText;
      articles = [];
    });
    loadArticles(buttonText);
  }

  @override
  void initState() {
    super.initState();
    loadArticles(selectedButton);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RIP NEWS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.newspaper),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()));
            },
            icon: Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => onButtonPressed('Technology'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:selectedButton == 'Technology' ? Colors.red : Colors.grey[300],
                      ),
                      child: Text(
                        'Technology',
                        style: TextStyle(
                          color: selectedButton == 'Technology' ? Colors.white : Colors.red[300],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onButtonPressed('Health'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:selectedButton == 'Health' ? Colors.red : Colors.grey[300],
                      ),
                      child: Text(
                        'Health',
                        style: TextStyle(
                          color: selectedButton == 'Health' ? Colors.white : Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onButtonPressed('Politics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:selectedButton == 'Politics' ? Colors.red : Colors.grey[300],
                      ),
                      child: Text(
                        'Politics',
                        style: TextStyle(
                          color: selectedButton == 'Politics' ? Colors.white : Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onButtonPressed('General'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:selectedButton == 'General' ? Colors.red : Colors.grey[300],
                      ),
                      child: Text(
                        'General',
                        style: TextStyle(
                          color: selectedButton == 'General' ? Colors.white : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

              ) ),

            const Divider(thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(5.0),
                      title: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              article['urlToImage'] ?? 'https://media.istockphoto.com/vectors/no-image-available-sign-vector-id1138179183?k=6&m=1138179183&s=612x612&w=0&h=prMYPP9mLRNpTp3XIykjeJJ8oCZRhb2iez6vKs8a8eE=' ,
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
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10, ),
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
            ),
          ],
        ),
      ),
    );
  }
}

