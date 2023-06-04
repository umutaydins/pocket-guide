// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'bussiness_searchbar.dart';
// class YourMainWidget extends StatefulWidget {
//   @override
//   _YourMainWidgetState createState() => _YourMainWidgetState();
// }

// class _YourMainWidgetState extends State<YourMainWidget> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> businessList = [];

//   void searchBusinesses(String searchQuery) async {
//     try {
//       final QuerySnapshot snapshot = await _firestore
//           .collection('businesses')
//           .where('name', isEqualTo: searchQuery)
//           .get();

//       setState(() {
//         businessList = snapshot.docs;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Business Search'),
//     ),
//     body: Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           BusinessSearchBar(
//             onSearch: searchBusinesses,
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: businessList.length,
//               itemBuilder: (context, index) {
//                 // ...
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }