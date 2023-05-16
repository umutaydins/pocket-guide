import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_guide/bussinessPage/business_homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessDetailedInformationPage extends StatefulWidget {
  @override
  _BusinessDetailedInformationPageState createState() =>
      _BusinessDetailedInformationPageState();
}

class _BusinessDetailedInformationPageState
    extends State<BusinessDetailedInformationPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<String> tags = ['bars', 'coffee', 'karaoke', 'restaurants'];
  List<String> pricing = ['cheap', 'standard', 'expensive'];

  Map<String, bool> selectedTags = {};
  Map<String, bool> selectedPricing = {};

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
              onPressed: () async {
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
                }, SetOptions(merge: true));

                // Navigate to the BusinessHomePage after confirming details
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BusinessHomePage(),
                  ),
                );
              },
              child: Text('Confirm Details'),
            ),
          ],
        ),
      ),
    );
  }
}
