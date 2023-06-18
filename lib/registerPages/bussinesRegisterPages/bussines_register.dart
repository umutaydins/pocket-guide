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
  final TextEditingController openFromController = TextEditingController();
  final TextEditingController locationController = TextEditingController();



  PickedFile? _profileImage;
  String price = '\$'; // Default price

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  List<PickedFile> _coverImages = [];
  List<String> tags = ['bars', 'coffee', 'karaoke', 'restaurants'];
    String _selectedTags = '';
    Map<String, bool> selectedTags = {};
    List<String> options = ['Eat-in', 'Take-away','Paid admission','Free-Pass'];

    


  List<String> pricing = ['cheap', 'standard', 'expensive'];
  Map<String, bool> selectedPricing = {};
   String _selectedOptions= '';
      Map<String, bool> selectedOptions = {};



  void _pickPrice(String price) {
    setState(() {
      selectedPricing.keys.forEach((key) {
        if (key == price) {
          selectedPricing[key] = true;
        } else {
          selectedPricing[key] = false;
        }
      });
    });
  }

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
    //tags string

    _selectedTags = '';
  selectedTags.entries.forEach((entry) {
    if (entry.value) {
      _selectedTags += entry.key + ',';
    }
  });

  // Son karakteri (virgülü) kaldırma
  if (_selectedTags.isNotEmpty) {
    _selectedTags = _selectedTags.substring(0, _selectedTags.length - 1);
  }
//option string
  _selectedOptions = '';
  selectedOptions.entries.forEach((entry) {
    if (entry.value) {
      _selectedOptions += entry.key + ',';
    }
  });

  // Son karakteri (virgülü) kaldırma
  if (_selectedOptions.isNotEmpty) {
    _selectedOptions = _selectedOptions.substring(0, _selectedOptions.length - 1);
  }

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
        'profile_picture': '',
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'description': descriptionController.text,
        'tags': selectedTags,
        'selectedTags':_selectedTags,
        'price': price,
        'detailsCompleted': true,
        'options': selectedOptions,
        'selectedOptions':_selectedOptions,
        'openFrom':openFromController.text,
        'location': locationController.text,




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

    options.forEach((tag) {
      selectedOptions[tag] = false;
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
                    child:
                        _profileImage == null ? Icon(Icons.add_a_photo) : null,
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
                  controller: openFromController,
                  decoration: InputDecoration(
                    labelText: 'Open-From',
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

  TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'location(google-maps link):',
                  ),
                ),

                SizedBox(height: 16),

                                Text('Please Select Tags'),


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

                          Text('Please Select options'),


                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: options.map((tag) {
                    return ChoiceChip(
                      label: Text(tag),
                      selected: selectedOptions[tag]!,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedOptions[tag] = selected;
                        });
                      },
                    );
                  }).toList(),
                ),
                Text('Please Select price range'),

                // price Dropdown Field
                DropdownButton<String>(
                  value: price,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      price = newValue!;
                    });
                  },
                  items: <String>['\$', '\$\$', '\$\$\$']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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