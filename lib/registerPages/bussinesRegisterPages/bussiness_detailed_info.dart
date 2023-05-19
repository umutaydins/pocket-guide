import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/bussinessPage/business_AppPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class BusinessDetailedInformationPage extends StatefulWidget {
  @override
  _BusinessDetailedInformationPageState createState() =>
      _BusinessDetailedInformationPageState();
}

class _BusinessDetailedInformationPageState
    extends State<BusinessDetailedInformationPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  List<PickedFile> _coverImages = []; // Changed to a list of PickedFiles
  List<String> tags = ['bars', 'coffee', 'karaoke', 'restaurants'];
  List<String> pricing = ['cheap', 'standard', 'expensive'];

  Map<String, bool> selectedTags = {};
  Map<String, bool> selectedPricing = {};

void incorrectUsage(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));

  // The context might no longer be valid here!
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => BusinessAppPage(),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    tags.forEach((tag) {
      selectedTags[tag] = false;
    });
    pricing.forEach((price) {
      selectedPricing[price] = false;
    });
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _coverImages.add(pickedImage!); // Add the picked image to the list
    });
  }

  Future<void> _uploadCoverImages(String userId) async {
    for (int i = 0; i < _coverImages.length; i++) {
      final file = File(_coverImages[i].path);
      final storageRef =
      FirebaseStorage.instance.ref().child('cover_photos/$userId-$i.jpg');

      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('businesses').doc(userId).update({
        'cover_photos': FieldValue.arrayUnion([downloadUrl]),
      });
    }
  }

    Future<void> detailedBusiness() async {
      final user = FirebaseAuth.instance.currentUser;
      // Validate your form fields before saving the data.
      await FirebaseFirestore.instance
          .collection('businesses')
          .doc(user!.uid)
          .set({
        'phoneNumber': phoneController.text,
        'description': descriptionController.text,
        'tags': selectedTags,
        'pricing': selectedPricing,
        'detailsCompleted': true,
      });
      if (_coverImages.isNotEmpty) {
        await _uploadCoverImages(user.uid);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BusinessAppPage(),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Business Detailed Information'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: tags.map((tag) {
                  return ChoiceChip(
                    label: Text(tag),
                    selected: selectedTags[tag]!,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedTags[tag] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: pricing.map((price) {
                  return ChoiceChip(
                    label: Text(price),
                    selected: selectedPricing[price]!,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPricing[price] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
              // Confirm Details Button
              ElevatedButton(
                onPressed: detailedBusiness,
                //async {
                //   final user = FirebaseAuth.instance.currentUser;
                //   // Validate your form fields before saving the data.
                //   await FirebaseFirestore.instance
                //       .collection('businesses')
                //       .doc(user!.uid)
                //       .set({
                //     'phoneNumber': phoneController.text,
                //     'description': descriptionController.text,
                //     'tags': selectedTags,
                //     'pricing': selectedPricing,
                //     'detailsCompleted': true,
                //
                //   }, SetOptions(merge: true));
                //
                //   // Navigate to the BusinessHomePage after confirming details
                //   Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(
                //       builder: (context) => BusinessHomePage(),
                //     ),
                //   );
                // },
                child: Text('Confirm Details'),
              ),
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text('Select Cover Photos'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Text('dssda'),
              if (_coverImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _coverImages.map((coverImage) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(coverImage.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      );
    }
  }
