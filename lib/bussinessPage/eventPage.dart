import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/bussinessPage/createEventPage.dart';

import '../components/colors.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // List<PickedFile> _eventPhotos = [];



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
                onPressed: () {  //_pickEventPhoto,
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateEvent()),
                  );
                },
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('event')
                  .where('business_id', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No events available'),
                  );
                }

                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>;

                      return Container(color: MyColors.whiteColor,
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.containsKey('event_photo') && data['event_photo'] != null)
                              Image.network(
                                data['event_photo'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                '${data['business_name']}',
                                style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text('  Description: ${data['description']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text('  Event Date: ${data['event_date']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text('  Price: ${data['price']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text('  Start: ${data['start_time']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 30,),
                                Text('  End: ${data['end_time']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Container(
            //   width: 393,
            //   height: 84*5,
            //   color: MyColors.backGroundkColor,
            //   child: Stack(
            //     children: [
            //       if (_eventPhotos.isNotEmpty)
            //         ListView.builder(
            //           scrollDirection: Axis.vertical,
            //           itemCount: _eventPhotos.length,
            //           itemBuilder: (context, index) {
            //             final photo = _eventPhotos[index];
            //             return Container(
            //               width: 393,
            //               height: 84*5,
            //               child: photo.path.startsWith('http')
            //                   ? Image.network(
            //                 photo.path,
            //                 fit: BoxFit.cover,
            //               )
            //                   : Image.file(
            //                 File(photo.path),
            //                 fit: BoxFit.cover,
            //               ),
            //             );
            //           },
            //         ),
            //       if (_eventPhotos.isEmpty)
            //         Center(
            //           child: Text('No cover images selected'),
            //         ),
            //     ],
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// Future<void> _pickEventPhoto() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.getImage(source: ImageSource.gallery);
//
//   if (pickedImage != null) {
//     final file = File(pickedImage.path);
//
//     if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
//       setState(() {
//         _eventPhotos.add(pickedImage);
//       });
//     }
//   }
//   showDialog(
//     context: context,
//     builder: (BuildContext context) => AlertDialog(
//       title: Text('Upload Photo'),
//       content: Text('Uploading the photo'),
//       actions: [
//         Center(
//           child: TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _uploadEventPhotos(_auth.currentUser!.uid);// Dialog kapatılıyor
//               // Fotoğrafı yükleme işlemi başlatılıyor
//             },
//             child: Text('OK'),
//           ),
//         ),
//       ],
//     ),
//   );
//   //await _uploadPostPhotos(_auth.currentUser!.uid);
// }

// Future<void> _uploadEventPhotos(String userId) async {
//   if (_eventPhotos.isEmpty) {
//     await _firestore.collection('businesses').doc(userId).update({
//
//       'event_photos': FieldValue.arrayUnion([]),
//     });
//     return;
//   }
//   for (int i = 0; i < _eventPhotos.length; i++) {
//     final file = File(_eventPhotos[i].path);
//
//     if (file.existsSync()) { // Dosyanın mevcutluğunu kontrol ediyoruz
//       final storageRef = FirebaseStorage.instance.ref().child('event_photos/$userId-$i.jpg');
//
//       await storageRef.putFile(file);
//
//       final downloadUrl = await storageRef.getDownloadURL();
//
//       await _firestore.collection('businesses').doc(userId).update({
//         'event_photos': FieldValue.arrayUnion([downloadUrl]),
//       });
//     }
//   }
// }


//
// Future<void> fetchBusinessData() async {
//   if (_eventPhotos.isEmpty) {
//     final userDoc = await _firestore
//         .collection('businesses')
//         .doc(_auth.currentUser!.uid)
//         .get();
//     final businessData = userDoc.data();
//
//     if (businessData != null) {
//       setState(() {
//         _eventPhotos = (businessData['event_photos'] as List<dynamic>)
//             .map((postPhotoPath) => PickedFile(postPhotoPath))
//             .toList();
//       });
//     }
//   }
// }
//
// void initState() {
//
//   super.initState();
//   fetchBusinessData();
//
// }
