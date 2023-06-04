import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessListingPage extends StatefulWidget {
  BusinessListingPage({Key? key}) : super(key: key);

  @override
  _BusinessListingPageState createState() => _BusinessListingPageState();
}

class _BusinessListingPageState extends State<BusinessListingPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> businesses = [];
  Map<String, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  void fetchTags() async {
    User? user = _auth.currentUser;
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user!.uid).get();
    if (doc.exists) {
      Map<String, dynamic>? tags = doc['tags'];
      if (tags != null) {
        Map<String, bool> convertedTags =
            tags.map((key, value) => MapEntry(key, value));
        setState(() {
          print('tagleri aldi');
          selectedTags = convertedTags;
        });
        getBusinesses();
      } else {
        print('No tags found for this user');
      }
    } else {
      print('User document does not exist');
    }
  }

  void getBusinesses() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('businesses').get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, bool> tags = Map<String, bool>.from(data['tags']);
      for (var tag in selectedTags.keys) {
        if (tags.containsKey(tag) &&
            tags[tag] == true &&
            selectedTags[tag] == true) {
          setState(() {
            businesses.add(doc);
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Businesses'),
      ),
      body: businesses.length > 0
          ? ListView.builder(
    shrinkWrap: true,   // use this if ListView is not scrolling, and inside another scrolling widget
    itemCount: businesses.length,
    itemBuilder: (context, index) {
        Map<String, dynamic> data = businesses[index].data() as Map<String, dynamic>;
        return ListTile(
            title: Text(data['name']),
            subtitle: Text(data['description']),
            leading: data['profile_picture'] != null
                ? Container(
                    width: 50.0,
                    height: 50.0,
                    child: Image.network(
                        data['profile_picture'],
                        fit: BoxFit.cover,   // this could help if the image is too big
                    ),
                )
                : null,
            onTap: () {
                // Navigate to business details page
            },
        );
    },
)

          : Center(child: Text('No businesses found')),
    );
  }
}
