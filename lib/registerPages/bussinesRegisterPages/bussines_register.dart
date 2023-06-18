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

  List<PickedFile> _coverImages = [];
  List<String> tags = ['bars', 'coffee', 'karaoke', 'restaurants'];
  List<String> pricing = ['cheap', 'standard', 'expensive'];

  Map<String, bool> selectedTags = {};
  Map<String, bool> selectedPricing = {};

  void registerBusiness() async {
    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_profileImage == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select a profile image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_coverImages.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please select at least one cover image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        phoneController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all the required fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      userCredential.user!.updateProfile(displayName: nameController.text);

      await _firestore.collection('businesses').doc(userCredential.user!.uid).set({
        'name': nameController.text,
        'profile_picture': '',
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'description': descriptionController.text,
        'tags': selectedTags,
        'pricing': selectedPricing,
        'detailsCompleted': true,
      });

      await _uploadProfileImage(userCredential.user!.uid);
      await _uploadCoverImages(userCredential.user!.uid);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BusinessAppPage(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
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
    final file = File(_profileImage!.path);
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

    await storageRef.putFile(file);

    final downloadUrl = await storageRef.getDownloadURL();

    await _firestore.collection('businesses').doc(userId).update({
      'profile_picture': downloadUrl,
    });
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _coverImages.add(pickedImage!);
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
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : null,
                    child: _profileImage == null ? Icon(Icons.add_a_photo) : null,
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),

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
