// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:pocket_guide/bussinessPage/post_page.dart';
// // import '../components/colors.dart';

// class PostPage extends StatefulWidget {
//   const PostPage({Key? key}) : super(key: key);

//   @override
//   State<PostPage> createState() => _PostPageState();
// }

// class _PostPageState extends State<PostPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final firebase_storage.FirebaseStorage _storage =
//       firebase_storage.FirebaseStorage.instance;
//   final ImagePicker _imagePicker = ImagePicker();
//   TextEditingController _titleController = TextEditingController();
//   String _selectedImageUrl = '';

//   // void _navigateToNextPage() {
//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => AddPostScreen()), // Replace `NextPage` with the actual page you want to navigate to
//   //   );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.backGroundkColor,
//       body: Container(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: GestureDetector(
//                 // onTap:_navigateToNextPage,
//                 child: Container(
//                   height: 50,
//                   width: 345,
//                   decoration: BoxDecoration(
//                     // color: MyColors.whiteColor,
//                     borderRadius: BorderRadius.circular(48),
//                     border: Border.all(
//                       width: 2,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Text(
//                             ' + Create new post',
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                               color: MyColors.primaryColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
