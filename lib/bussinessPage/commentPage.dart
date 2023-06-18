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
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0; // Update to int type

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
      'rating': _rating,
    });

    _commentController.clear();
    setState(() {
      _rating = 0;
    });

    // Update total rating and average rating
    final querySnapshot = await _firestore
        .collection('businesses')
        .doc(widget.businessId)
        .collection('comments')
        .get();

    final comments = querySnapshot.docs;
    double totalRating = 0.0;
    int totalRatingCount = comments.length;
    for (final comment in comments) {
      final rating = comment['rating'] ?? 0;
      totalRating += rating.toDouble();
    }
    final averageRating = totalRating / totalRatingCount;

    // Update totalRating and totalRatingCount in businesses collection
    await _firestore.collection('businesses').doc(widget.businessId).update({
      'totalRating': averageRating,
      'totalRatingCount': totalRatingCount,
    });
  }
}


  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
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
          // Business Data
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('businesses')
                .doc(widget.businessId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('Business data not found.');
              }

              final businessData =
                  snapshot.data!.data() as Map<String, dynamic>;
              final totalRating = businessData['totalRating'] as double? ?? 0.0;
              final totalRatingCount =
                  businessData['totalRatingCount'] as int? ?? 0;

              return Column(
                children: [
                  Text(
                    'Average Rating: $totalRating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total Rating Count: $totalRatingCount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                ],
              );
            },
          ),

          // Comments
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

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment['comment']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['name_surname']),
                          Row(
                            children: List.generate(
                              comment['rating'],
                              (index) => Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          // Comment Entry
          if (_isUserBusinessOwner)
            Container(
              padding: EdgeInsets.all(8),
              child: Text('You cannot add comments to your own business.'),
            )
          else
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildRatingStars(),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                    ),
                    onSubmitted: (text) => _addComment(text),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
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
