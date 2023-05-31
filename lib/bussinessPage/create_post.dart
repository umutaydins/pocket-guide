import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostWidget extends StatefulWidget {

  CreatePostWidget({super.key, });

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final _captionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _imageUrl = '';


 final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  void _createPost() {
    CollectionReference posts = FirebaseFirestore.instance
        .collection('businesses')
        .doc(_auth.currentUser!.uid)
        .collection('posts');

    posts
        .add({
      'caption': _captionController.text, 
      'image': _imageUrl, 
      'timestamp': DateTime.now(),
    })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageUrl = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _captionController,
          decoration: InputDecoration(
            labelText: 'Caption',
          ),
        ),
        ElevatedButton(
          child: Text('Select Image'),
          onPressed: _pickImage,
        ),
        if (_imageUrl != '')
          Image.file(
            File(_imageUrl),
            height: 200,
            width: 200,
          ),
        ElevatedButton(
          child: Text('Create Post'),
          onPressed: _imageUrl != '' ? _createPost : null,
        ),
      ],
    );
  }
}