import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'dart:io';



class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController nameSurnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  String gender = 'Male'; // Default gender
  DateTime selectedDate = DateTime.now(); // Default birthday
  PickedFile? _profileImage;

Future<void> _pickProfileImage() async {
  final picker = ImagePicker();
  final pickedImage = await picker.getImage(source: ImageSource.gallery);

  setState(() {
    _profileImage = pickedImage;
  });
}
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  Future<void> _uploadProfileImage(String userId) async {
    if (_profileImage != null) {
      final file = File(_profileImage!.path);
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

      await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'profile_picture': downloadUrl,
      });
    }
  }



 void registerUser() async {
  if (passwordController.text == confirmPasswordController.text) {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      userCredential.user!.updateProfile(displayName: nameSurnameController.text);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name_surname': nameSurnameController.text,
        'birthday': DateFormat('yyyy-MM-dd').format(selectedDate),
        'gender': gender,
        'email': emailController.text,
        'interests': [],
      });

      if (_profileImage != null) {
        await _uploadProfileImage(userCredential.user!.uid);
      }

      Navigator.of(context).pop();

    } catch (e) {
      print(e);
    }
  }
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
                    backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
                    child: _profileImage == null ? Icon(Icons.add_a_photo) : null,
                    ),
                    ),
                // Profile Photo Selection
                
                SizedBox(height: 16),

                
                // Name and Surname Text Field
                TextField(
                  controller: nameSurnameController,
                  decoration: InputDecoration(
                    labelText: "Name and Surname",
                  ),
                ),

                // Birthday Date Picker
                ListTile(
                  title: Text("Birthday: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDate(context);
                  },
                ),

                // Gender Dropdown Field
                DropdownButton<String>(
                  value: gender,
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
                      gender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),

                // Confirm Password Text Field
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  obscureText: true,
                ),

                // Register Button
                ElevatedButton(
                  onPressed: registerUser,
                  child: Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

