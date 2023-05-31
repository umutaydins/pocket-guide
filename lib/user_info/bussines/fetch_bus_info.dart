import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  final String infoType;

  UserInfoWidget({required this.infoType});

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    } else {
      setState(() {
        _currentUserId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Text(
        'No user is currently signed in.',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('businesses')
            .doc(_currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || data.isEmpty) {
            return Text(
              'Data not available',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            );
          } else   {




            if (widget.infoType == 'name') {
              final name = data['name'] as String?;
              return Text(
                name ?? 'Name not available',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            } 
            
            
            
            
            else if (widget.infoType == 'description') {
              final description = data['description'] as String?;
              return Text(
                description ?? 'Description not available',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            }


            

            return SizedBox(
              child: Text('InfoType not supported'),
            );
          }
        },
      );
    }
  }
}
