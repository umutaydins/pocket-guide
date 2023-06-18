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
  String _selectedTags = '';
  Map<String, bool> selectedTags = {};
  final TextEditingController tagController = TextEditingController();

  String _selectedOptions = '';
  Map<String, bool> selectedOptions = {};
  final TextEditingController OptionController = TextEditingController();

  // Map<String, bool> selectedPricing = {};
  // final TextEditingController pricingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTags();
    fetchOptions();
    // fetchPricing();
  }

  void UpdateCombine() {
    updateTags();
    updateOptions();
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

  void fetchOptions() async {
    DocumentSnapshot doc =
        await _firestore.collection('businesses').doc(user!.uid).get();
    Map<String, dynamic> options = Map<String, dynamic>.from(doc['options']);

    Map<String, bool> convertedOptions =
        options.map((key, value) => MapEntry(key, value));
    setState(() {
      selectedOptions = convertedOptions;
    });
  }

  // void fetchPricing() async {
  //   DocumentSnapshot doc =
  //       await _firestore.collection('businesses').doc(user!.uid).get();
  //   Map<String, dynamic> pricing = Map<String, dynamic>.from(doc['pricing']);
  //   Map<String, bool> convertedPricing =
  //       pricing.map((key, value) => MapEntry(key, value));
  //   setState(() {
  // selectedPricing = convertedPricing;
  // print('price');
  // print(selectedPricing);
  //   });
  // }

  // void updatePricing() async {
  //   await _firestore.collection('businesses').doc(user!.uid).update({
  //     'pricing': selectedPricing,
  //   });
  //   Navigator.of(context).pop();
  // }

  void addTag() {
    String newTag = tagController.text.trim();
    if (newTag.isNotEmpty && !selectedTags.containsKey(newTag)) {
      setState(() {
        selectedTags[newTag] = true;
      });
      tagController.clear();
    }
  }

  void addOptions() {
    String newOption = OptionController.text.trim();
    if (newOption.isNotEmpty && !selectedOptions.containsKey(newOption)) {
      setState(() {
        selectedOptions[newOption] = true;
      });
      OptionController.clear();
    }
  }

  void updateTags() async {
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

    await _firestore.collection('businesses').doc(user!.uid).update({
      'tags': selectedTags,
      'selectedTags': _selectedTags,
    });
  }

  void updateOptions() async {
    _selectedOptions = '';
    selectedOptions.entries.forEach((entry) {
      if (entry.value) {
        _selectedOptions += entry.key + ',';
      }
    });

    // Son karakteri (virgülü) kaldırma
    if (_selectedOptions.isNotEmpty) {
      _selectedOptions =
          _selectedOptions.substring(0, _selectedOptions.length - 1);
    }

    await _firestore.collection('businesses').doc(user!.uid).update({
      'options': selectedOptions,
      'selectedOptions': _selectedOptions,
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
            TextField(
              controller: OptionController,
              decoration: InputDecoration(
                labelText: 'Add Option',
              ),
            ),
            
            ElevatedButton(
              onPressed: addOptions,
              child: Text('Add Option'),
            ),

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedOptions.entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: entry.value,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedOptions[entry.key] = selected;
                    });


                  },
                );
              }).
              
              toList(),
            ),
            ElevatedButton(
              onPressed: UpdateCombine,
              child: Text('Update Tags'),
            ),
            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 4.0,
            //   children: selectedPricing.entries.map((entry) {
            //     return ChoiceChip(
            //       label: Text(entry.key),
            //       selected: entry.value,
            //       onSelected: (bool selected) {
            //         setState(() {
            //           selectedPricing[entry.key] = selected;
            //         });
            //       },
            //     );
            //   }).toList(),
            // ),
            // ElevatedButton(
            //   onPressed: updatePricing,
            //   child: Text('Update Pricing'),
            // ),
          ],
        ),
      ),
    );
  }
}
