import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditUserInterestPage extends StatefulWidget {
  @override
  _EditUserInterestPageState createState() =>
      _EditUserInterestPageState();
}

class _EditUserInterestPageState extends State<EditUserInterestPage> {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Map<String, bool> selectedTags = {};
  final TextEditingController tagController = TextEditingController();

  Map<String, bool> selectedPricing = {};
  final TextEditingController pricingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTags();
    // fetchPricing();
  }

  void fetchTags() async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user!.uid).get();
    Map<String, dynamic> tags = Map<String, dynamic>.from(doc['tags']);
    Map<String, bool> convertedTags =
        tags.map((key, value) => MapEntry(key, value));
    setState(() {
      selectedTags = convertedTags;
    });
  }
  
  void updateTags() async {
    await _firestore.collection('users').doc(user!.uid).update({
      'tags': selectedTags,
    });
    Navigator.of(context).pop();
  }
  void addTag() {
    String newTag = tagController.text.trim();
    if (newTag.isNotEmpty && !selectedTags.containsKey(newTag)) {
      setState(() {
        selectedTags[newTag] = true;
      });
      tagController.clear();
    }
  }

 

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Interests'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                labelText: 'Add Tag',
              ),
            ),
            ElevatedButton(
              onPressed: addTag,
              child: Text('Add Tag'),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedTags.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedTags[entry.key] = selected;
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: updateTags,
              child: Text('Update Tags'),
            ),
       
          ],
        ),
      ),
    );
  }
}
