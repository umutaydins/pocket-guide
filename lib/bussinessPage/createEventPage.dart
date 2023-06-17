import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String _businessName = '';
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  PickedFile? _eventPhoto;

  Future<void> _pickEventPhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _eventPhoto = pickedImage;
    });
  }

  Future<void> _uploadEventPhoto(DocumentReference eventRef) async {
    if (_eventPhoto != null) {
      final storageRef = FirebaseStorage.instance.ref().child('event_photos/${eventRef.id}.png');

      final uploadTask = storageRef.putFile(File(_eventPhoto!.path));
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await storageRef.getDownloadURL();

      await eventRef.update({
        'event_photo': downloadUrl,
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  late String _description;
  late String _eventDate;
  late String _startTime;
  late String _endTime;
  late double _price;

  @override
  void initState() {
    fetchBusinessData();
    super.initState();
  }

  Future<void> fetchBusinessData() async {
    final userDoc = await _firestore.collection('businesses').doc(_auth.currentUser!.uid).get();
    final businessData = userDoc.data();

    if (businessData != null) {
      setState(() {
        _businessName = businessData['name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: _pickEventPhoto,
                child: Text('Pick Event Photo'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Date'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventDate = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter start time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _startTime = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter end time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _endTime = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    saveEventToFirestore();
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveEventToFirestore() {
    final eventRef = _firestore.collection('event').doc();
    eventRef.set({
      'description': _description,
      'business_name': _businessName,
      'business_id': _auth.currentUser!.uid,
      'event_date': _eventDate,
      'start_time': _startTime,
      'end_time': _endTime,
      'price': _price,
    }).then((value) {
      print('Event saved successfully');
      _uploadEventPhoto(eventRef);
    }).catchError((error) {
      print('Failed to save event: $error');
    });
  }
}
