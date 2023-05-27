import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_guide/bussinessPage/business_AppPage.dart';
import 'package:pocket_guide/components/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_guide/registerPages/bussinesRegisterPages/bussiness_detailed_info.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BusinessRegisterPage extends StatefulWidget {
  const BusinessRegisterPage({Key? key}) : super(key: key);

  @override
  _BusinessRegisterPageState createState() => _BusinessRegisterPageState();
}

class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  LatLng? selectedLocation;
  PickedFile? _profileImage;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<PickedFile> _coverImages = []; // Changed to a list of PickedFiles
  List<String> tags = ['bars', 'coffee', 'karaoke', 'restaurants'];
  List<String> pricing = ['cheap', 'standard', 'expensive'];

  Map<String, bool> selectedTags = {};
  Map<String, bool> selectedPricing = {};

  void registerBusiness() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        userCredential.user!.updateProfile(displayName: nameController.text);

        await _firestore
            .collection('businesses')
            .doc(userCredential.user!.uid)
            .set({
          'name': nameController.text,
          // 'description': descriptionController.text,
          // 'location': selectedLocation != null
          //     ? GeoPoint(
          //         selectedLocation!.latitude, selectedLocation!.longitude)
          //     : null,
          //'tags': tagsController.text.split(","),
          'profile_picture': '',
          'email': emailController.text,
          'password': passwordController.text,
          'phoneNumber': phoneController.text,
          'description': descriptionController.text,
          'tags': selectedTags,
          'pricing': selectedPricing,
          'detailsCompleted': true,

          'detailsCompleted': true, // Set detailsCompleted as false
        });
        if (_profileImage != null) {
          await _uploadProfileImage(userCredential.user!.uid);
        }
        if (_coverImages.isNotEmpty) {
        await _uploadCoverImages(userCredential.user!.uid);
      }
        // Navigate to the BusinessDetailedInformationPage after successful registration
        print('got');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BusinessAppPage(),
          ),
        );
        print('hop');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _profileImage = pickedImage;
    });
  }

  Future<void> _uploadProfileImage(String userId) async {
    if (_profileImage != null) {
      final file = File(_profileImage!.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('businesses').doc(userId).update({
        'profile_picture': downloadUrl,
      });
    }
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
  // void openMapScreen() async {
  //   final LatLng? selectedLocation = await Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => MapScreen()),
  //   );

  //   setState(() {
  //     this.selectedLocation = selectedLocation;
  //   });
  // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  // Profile Photo Selection
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : null,
                    child:
                        _profileImage == null ? Icon(Icons.add_a_photo) : null,
                  ),
                ),
                // Profile Photo Selection

                SizedBox(height: 16),
                // Name Text Field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),

                // Email Text Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),

                // Password Text Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),

                // Confirm Password Text Field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),

                SizedBox(height: 16),

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

                SizedBox(
                  height: 20,
                ),
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
                // Register Button
                ElevatedButton(
                  onPressed: registerBusiness,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
