import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/usersPages/go_business.dart';
import 'package:pocket_guide/usersPages/user_home_page.dart';
import '../components/colors.dart';



class GoPostPage extends StatefulWidget {

  final Business business;
  const GoPostPage({Key? key, required this.business}) : super(key: key);

  @override
  State<GoPostPage> createState() => _GoPostPageState();
}

class _GoPostPageState extends State<GoPostPage> {
  Business get business => widget.business;


  void initState() {

    super.initState();
    // fetchBusinessData();

  }


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),

            SizedBox(height: 20,),

            SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Container(
                  width: 393,
                  height: 84*5,
                  color: MyColors.backGroundkColor,
                  child: Stack(
                    children: [
                      if (business.postPhotos.isNotEmpty)
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Her satırda 3 fotoğraf
                          ),
                          itemCount: business.postPhotos.length,
                          itemBuilder: (context, index) {
                            final photo = business.postPhotos[index];

                            return Container(
                              width: 393 / 3, // Her fotoğrafın genişliği
                              height: 252 / 3, // Her fotoğrafın yüksekliği
                              child: photo.startsWith('http')
                                  ? Image.network(
                                photo,
                                fit: BoxFit.cover,
                              )
                                  : Image.file(
                                File(photo),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),


                      if (business.postPhotos.isEmpty)
                        Center(
                          child: Text('No post images selected'),
                        ),
                    ],
                  ),
                ),
                //   ],
                // ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
// Row(
//   children: [
//     SizedBox(width: 24,),
//     Container(
//       width: 114,
//       height: 114,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       // Resmin yolunu buraya ekleyin
//     ),
//   ],
// ),

// Container(
//   width: 345,
//   height: 48,
//   child: FilledButton(
//     onPressed: () {
//       _uploadPostPhotos(_auth.currentUser!.uid);
//     },
//     style: FilledButton.styleFrom(
//       backgroundColor: MyColors.whiteColor,
//     ),
//     child: Text(
//       'Post it',
//       style: GoogleFonts.inter(
//         fontSize: 16.0,
//         fontWeight: FontWeight.w600,
//         color: MyColors.primaryColor,
//       ),
//     ),
//   ),
// ),
