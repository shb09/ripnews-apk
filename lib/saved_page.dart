import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newsly/profile_page.dart';

import 'detail_page.dart';

class SavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("RIP NEWS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 2),
            Text("Saved", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),

          ],
        ),
        centerTitle: true,
        leading: const Icon(Icons.article_rounded),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_2_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No articles found.'));
          }

          final articles = snapshot.data!.docs;
          articles.sort((a, b) {
            final dateA = DateTime.parse(a['publishedAt']);
            final dateB = DateTime.parse(b['publishedAt']);
            return dateB.compareTo(dateA); // Sort in descending order (newest first)
          });

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(5.0),
                  title: Column(
                    children: [
                      Text(article['title'] ?? 'No title',
                        maxLines: null, // Allow unlimited lines
                        overflow: TextOverflow.visible,),
                    ]
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                  Text(article['source']['name'] ?? "Unknown source",),
                  Text(article['author'] ?? 'Unknown author'),
                  Text(article['publishedAt'] ?? 'Unknown time')
                    ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          article: article.data() as Map<String, dynamic>, // Correctly pass individual article
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
