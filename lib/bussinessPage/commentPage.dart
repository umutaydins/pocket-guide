import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final String businessId;

  CommentPage({required this.businessId});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController(); // Add TextEditingController


  bool _isUserBusinessOwner = false;
  late Stream<QuerySnapshot> _commentsStream;

  @override
  void initState() {
    super.initState();

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _isUserBusinessOwner = currentUser.uid == widget.businessId;
    }

    _commentsStream = _firestore
        .collection('businesses')
        .doc(widget.businessId)
        .collection('comments')
        .snapshots();
  }

  Future<void> _addComment(String commentText) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userData =
      await _firestore.collection('users').doc(currentUser.uid).get();

      final username = userData['name_surname'];
      // Kullanıcının adını al

      print('Adding comment: $commentText');
      await _firestore
          .collection('businesses')
          .doc(widget.businessId)
          .collection('comments')
          .add({
        'businessId': widget.businessId,
        'userId': currentUser.uid,
        'name_surname': username,
        'comment': commentText,
      });
      _commentController.clear();
    }
  }
  @override
  void dispose() {
    _commentController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Page'),
      ),
      body: Column(
        children: [
          // İşletme Verileri

          Divider(),
          // Yorumlar
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Text('No comments found.');
                }

                final comments = snapshot.data!.docs; // Yorumları al

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment['comment']),
                      subtitle: Text(comment['name_surname']),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          // Yorum Ekleme Düğmesi
          if (_isUserBusinessOwner)
            Container(
              padding: EdgeInsets.all(8),
              child: Text('You cannot add comments to your own business.'),
            )
          else
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                      ),
                      onSubmitted: (text) => _addComment(text),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Yorum düğmesine basıldığında yorumu ekle
                      _addComment(_commentController.text);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
