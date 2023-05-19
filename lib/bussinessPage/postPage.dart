import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '../components/colors.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _titleController = TextEditingController();
  String _selectedImageUrl = '';

  Future<void> _uploadImage() async {
    final image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final destination = 'post_photos/$fileName';

      try {
        await _storage.ref(destination).putFile(file);
        final imageUrl = await _storage.ref(destination).getDownloadURL();
        setState(() {
          _selectedImageUrl = imageUrl;
        });
      } catch (e) {
        // Hata durumunda işlemler yapabilirsiniz
      }
    }
  }

  Future<void> _sharePost() async {
    final title = _titleController.text;
    final createdAt = Timestamp.now();

    try {
      await _firestore.collection('businesses').add({
        'title': title,
        'imageURL': _selectedImageUrl,
        'createdAt': createdAt,
      });

      // Gönderiyi paylaştıktan sonra işlemler yapabilirsiniz

      // Örneğin, paylaşım tamamlandıktan sonra formu sıfırlayabilirsiniz:
      _titleController.clear();
      setState(() {
        _selectedImageUrl == null;
      });
    } catch (e) {
      // Hata durumunda işlemler yapabilirsiniz
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Galeriden Görsel Seç'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sharePost,
                child: Text('Gönderiyi Paylaş'),
              ),
              _selectedImageUrl != null && _selectedImageUrl.startsWith('http')
                  ? Image.network(_selectedImageUrl)
                  : Container(),
              SizedBox(
                height: 90,
              ),
              Text('sdhsd')
            ],
          ),
        ),
      ),
    );
  }
}
