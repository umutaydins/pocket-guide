import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../components/colors.dart';
import 'createPostPhoto.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<PickedFile> _postPhotos = [];

  Future<void> _pickPostPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);

      if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
        setState(() {
          _postPhotos.add(pickedImage);
        });
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Upload Photo'),
        content: Text('Uploading the photo'),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                 _uploadPostPhotos(_auth.currentUser!.uid);// Dialog kapatılıyor
                 // Fotoğrafı yükleme işlemi başlatılıyor
              },
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
    //await _uploadPostPhotos(_auth.currentUser!.uid);
  }

  Future<void> _uploadPostPhotos(String userId) async {
    if (_postPhotos.isEmpty) {
      await _firestore.collection('businesses').doc(userId).update({

        'post_photos': FieldValue.arrayUnion([]),
      });
      return;
    }
    for (int i = 0; i < _postPhotos.length; i++) {
      final file = File(_postPhotos[i].path);

      if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
        final storageRef = FirebaseStorage.instance.ref().child('post_photos/$userId-$i.jpg');

        await storageRef.putFile(file);

        final downloadUrl = await storageRef.getDownloadURL();

        await _firestore.collection('businesses').doc(userId).update({
          'post_photos': FieldValue.arrayUnion([downloadUrl]),
        });
      }
    }
  }

  Future<void> fetchBusinessData() async {
    if (_postPhotos.isEmpty) {
      final userDoc = await _firestore
          .collection('businesses')
          .doc(_auth.currentUser!.uid)
          .get();
      final businessData = userDoc.data();

      if (businessData != null) {
        setState(() {
          _postPhotos = (businessData['post_photos'] as List<dynamic>)
              .map((postPhotoPath) => PickedFile(postPhotoPath))
              .toList();
        });
      }
    }
  }

  void initState() {

    super.initState();
    fetchBusinessData();

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
            Container(
              width: 345,
              height: 48,
              child: ElevatedButton(
                onPressed: _pickPostPhoto,
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.whiteColor,
                ),
                child: Text(
                  '+ Create new post',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
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
                      if (_postPhotos.isNotEmpty)
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Her satırda 3 fotoğraf
                          ),
                          itemCount: _postPhotos.length,
                          itemBuilder: (context, index) {
                            final photo = _postPhotos[index];

                            return Container(
                              width: 393 / 3, // Her fotoğrafın genişliği
                              height: 252 / 3, // Her fotoğrafın yüksekliği
                              child: photo.path.startsWith('http')
                                  ? Image.network(
                                photo.path,
                                fit: BoxFit.cover,
                              )
                                  : Image.file(
                                File(photo.path),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),


                      if (_postPhotos.isEmpty)
                        Center(
                          child: Text('No cover images selected'),
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
