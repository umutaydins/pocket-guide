import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../components/colors.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<PickedFile> _eventPhotos = [];

  Future<void> _pickEventPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);

      if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
        setState(() {
          _eventPhotos.add(pickedImage);
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
                _uploadEventPhotos(_auth.currentUser!.uid);// Dialog kapatılıyor
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

  Future<void> _uploadEventPhotos(String userId) async {
    for (int i = 0; i < _eventPhotos.length; i++) {
      final file = File(_eventPhotos[i].path);

      if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
        final storageRef = FirebaseStorage.instance.ref().child('event_photos/$userId-$i.jpg');

        await storageRef.putFile(file);

        final downloadUrl = await storageRef.getDownloadURL();

        await _firestore.collection('businesses').doc(userId).update({
          'event_photos': FieldValue.arrayUnion([downloadUrl]),
        });
      }
    }
  }

  Future<void> fetchBusinessData() async {
    if (_eventPhotos.isEmpty) {
      final userDoc = await _firestore
          .collection('businesses')
          .doc(_auth.currentUser!.uid)
          .get();
      final businessData = userDoc.data();

      if (businessData != null) {
        setState(() {
          _eventPhotos = (businessData['event_photos'] as List<dynamic>)
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
  @override
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
                onPressed: _pickEventPhoto,
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.whiteColor,
                ),
                child: Text(
                  '+ Create new event',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
            Container(
              width: 393,
              height: 84*5,
              color: MyColors.backGroundkColor,
              child: Stack(
                children: [
                  if (_eventPhotos.isNotEmpty)
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _eventPhotos.length,
                      itemBuilder: (context, index) {
                        final photo = _eventPhotos[index];
                        return Container(
                          width: 393,
                          height: 84*5,
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
                  if (_eventPhotos.isEmpty)
                    Center(
                      child: Text('No cover images selected'),
                    ),
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
