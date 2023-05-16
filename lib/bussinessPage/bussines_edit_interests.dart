import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditBusinessInterestPage extends StatefulWidget {
  @override
  _EditBusinessInterestPageState createState() =>
      _EditBusinessInterestPageState();
}

class _EditBusinessInterestPageState extends State<EditBusinessInterestPage> {
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
    fetchPricing();
  }

  void fetchTags() async {
    DocumentSnapshot doc =
        await _firestore.collection('businesses').doc(user!.uid).get();
    Map<String, dynamic> tags = Map<String, dynamic>.from(doc['tags']);
    Map<String, bool> convertedTags =
        tags.map((key, value) => MapEntry(key, value));
    setState(() {
      selectedTags = convertedTags;
    });
  }

  void fetchPricing() async {
    DocumentSnapshot doc =
        await _firestore.collection('businesses').doc(user!.uid).get();
    Map<String, dynamic> pricing = Map<String, dynamic>.from(doc['pricing']);
    Map<String, bool> convertedPricing =
        pricing.map((key, value) => MapEntry(key, value));
    setState(() {
      selectedPricing = convertedPricing;
    });
  }
  void updatePricing() async {
    await _firestore.collection('businesses').doc(user!.uid).update({
      'pricing': selectedPricing,
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

  void updateTags() async {
    await _firestore.collection('businesses').doc(user!.uid).update({
      'tags': selectedTags,
    });
    Navigator.of(context).pop();
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
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedPricing.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPricing[entry.key] = selected;
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: updatePricing,
              child: Text('Update Pricing'),
            ),
          ],
        ),
      ),
    );
  }
}
