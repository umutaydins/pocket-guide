// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class BusinessSearchBar extends StatefulWidget {
//   final Function(String) onSearch;

//   BusinessSearchBar({required this.onSearch});

//   @override
  // _BusinessSearchBarState createState() => _BusinessSearchBarState();
// }

// class _BusinessSearchBarState extends State<BusinessSearchBar> {
//   String searchQuery = '';

//   void searchBusinesses() {
//     widget.onSearch(searchQuery);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey[300],
//       ),
//       child: TextField(
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//           color: Colors.black,
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.only(left: 8, bottom: 5),
//           hintText: 'What are you looking for?',
//           hintStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         onChanged: (value) {
//           setState(() {
//             searchQuery = value;
//           });
//         },
//         onSubmitted: (value) {
//           searchBusinesses();
//         },
//       ),
//     );
//   }
// }
