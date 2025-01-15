import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> article;

  DetailScreen({required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  bool isSaved = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkIfSaved() async {
    try {
      final query = await _firestore
          .collection('articles')
          .where('title', isEqualTo: widget.article['title']) // Use title or unique identifier
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          isSaved = true;
        });
      }
    } catch (e) {
      print('Error checking saved status: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfSaved(); // Check save status when the screen loads
  }
  Future<void> deleteArticle(BuildContext context) async {
    try {
      final query = await _firestore
          .collection('articles')
          .where('title', isEqualTo: widget.article['title'])
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }

      setState(() {
        isSaved = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article removed from saved items.')),
      );
    } catch (e) {
      print('Error deleting article: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove article: $e')),
      );
    }
  }
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to remove this article from saved items?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteArticle(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.article['urlToImage'] ?? 'https://media.istockphoto.com/vectors/no-image-available-sign-vector-id1138179183?k=6&m=1138179183&s=612x612&w=0&h=prMYPP9mLRNpTp3XIykjeJJ8oCZRhb2iez6vKs8a8eE=' ,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  // Title with enhanced typography
                  Text(
                    widget.article['title'] ?? " ",
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Text(widget.article['author'] ?? ' '),
                  const Divider(),

                  SizedBox(height: 8.0),
                  const Text(
                    "Content" ,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Article description with better padding
                  Text(
                    widget.article['content'] ?? " ",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  // Add a divider for extra separation
                  Divider(),
                  SizedBox(height: 20.0),
                  ElevatedButton(onPressed: ()async{
                    if (isSaved) {
                      showDeleteConfirmationDialog(context);
                    } else {
                      try {
                        await _firestore.collection('articles').add(widget.article);
                        setState(() {
                        isSaved = true;
                      });
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('saved')),
                      );
                      } catch (e) {
                        print('Error saving article: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save : $e')),
                      );
                      }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  child: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
