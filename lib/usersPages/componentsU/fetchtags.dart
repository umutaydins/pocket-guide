import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/components/colors.dart';

class SelectaTagAndList extends StatefulWidget {
  @override
  _SelectaTagAndListState createState() => _SelectaTagAndListState();
}

class _SelectaTagAndListState extends State<SelectaTagAndList> {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Map<String, bool> userTags = {};
  List<DocumentSnapshot> selectedBusinesses = [];
  final TextEditingController tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  void fetchTags() async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(user!.uid).get();
    Map<String, dynamic> tags = Map<String, dynamic>.from(doc['tags']);
    Map<String, bool> convertedTags = tags.map((key, value) => MapEntry(key, value));
    setState(() {
      userTags = convertedTags;
    });
  }

  void handleTagPressed(String tag) {
    // Etiket üzerine tıklandığında yapılmasını istediğiniz işlemleri buraya ekleyin
    print('Tapped on tag: $tag');
    if (userTags[tag] == true) {
      getBusinessesByTag(tag);
    }
  }

  void getBusinessesByTag(String tag) async {
    QuerySnapshot querySnapshot = await _firestore.collection('businesses').where('tags.$tag', isEqualTo: true).get();

    setState(() {
      selectedBusinesses = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Filter Tags',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: MyColors.primaryColor,
          ),
        ),
      ),
      backgroundColor: MyColors.backGroundkColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: userTags.entries.map((entry) {
                  final String tag = entry.key;
                  final bool selected = entry.value;

                  return InkWell(
                    onTap: () {
                      handleTagPressed(tag);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tag,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: MyColors.thirdTextColor,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                userTags[tag] = !selected;
                              });
                            },
                            color: selected ? MyColors.primaryColor : MyColors.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Businesses',
               style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: MyColors.thirdTextColor,
            ),
            ),
            SizedBox(height: 10.0),
            selectedBusinesses.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedBusinesses.length,
                    itemBuilder: (context, index) {
                      final business = selectedBusinesses[index];
                      final businessData = business.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(businessData['name'],style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: MyColors.thirdTextColor,
                        ),),
                        subtitle: Text(businessData['description'],
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: MyColors.thirdTextColor,
                            ),),
                        leading: businessData['profile_picture'] != null
                            ? Container(
                                width: 50.0,
                                height: 50.0,
                                child: Image.network(
                                  businessData['profile_picture'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                        onTap: () {
                          // Navigate to business details page
                          print('Tapped on business: ${businessData['name']}');
                        },
                      );
                    },
                  )
                : Text('No businesses found',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: MyColors.errorColor,
              ),),
          ],
        ),
      ),
    );
  }
}
