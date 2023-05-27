import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String userId;
  final String infoType;

  UserInfoWidget({required this.userId, required this.infoType});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bussiness')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        
        if (infoType == 'name') {
          final name = data['name'] as String;
          return Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          );
        } else if (infoType == 'arkadaslar') {
          final arkadaslar = data['arkadaslar'] as List<dynamic>;
          final arkadaslarList = arkadaslar.map((arkadas) => arkadas as String).toList();
          return Text(
            arkadaslarList.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
