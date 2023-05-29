import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/bussinessPage/postPage.dart';

import '../components/colors.dart';

class CreatePost extends StatefulWidget {

  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();

}

class _CreatePostState extends State<CreatePost> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  List<PickedFile> _postPhotos = [];
  PickedFile? _selectedPhoto;

  Future<void> _pickPostPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _selectedPhoto = pickedImage;
      _postPhotos.add(pickedImage!);

    });
    // await _uploadPostPhotos(_auth.currentUser!.uid);
  }

  Future<void> _uploadPostPhotos(String userId) async {
    for (int i = 0; i < _postPhotos.length; i++) {
      final file = File(_postPhotos[i].path);
      final storageRef =
          FirebaseStorage.instance.ref().child('post_photos/$userId-$i.jpg');

      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('businesses').doc(userId).update({
        'post_photos': FieldValue.arrayUnion([downloadUrl]),
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.transparent,
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            if (_selectedPhoto != null)
              Container(
                width: 200,
                height: 200,
                child: Image.file(
                  File(_selectedPhoto!.path),
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _pickPostPhoto,
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _uploadPostPhotos(_auth.currentUser!.uid);
                Navigator.pop(context);

                // PostPage'nin güncellenmesi için fetchBusinessData() çağrısı ekleyin

              },
              child: Text('Post Image'),
            ),

          ],
        ),
      ),
    );
  }
}
