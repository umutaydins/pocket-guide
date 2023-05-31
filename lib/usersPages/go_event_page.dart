import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/usersPages/go_business.dart';
import 'package:pocket_guide/usersPages/user_home_page.dart';

import '../components/colors.dart';

class GoEventPage extends StatefulWidget {
  final Business business;
  const GoEventPage({Key? key, required this.business,}) : super(key: key);

  @override
  State<GoEventPage> createState() => _GoEventPageState();
}

class _GoEventPageState extends State<GoEventPage> {
  Business get business => widget.business;


  List<PickedFile> _eventPhotos = [];






  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),

            SizedBox(height: 40,),
            Container(
              width: 393,
              height: 84*5,
              color: MyColors.backGroundkColor,
              child: Stack(
                children: [
                  if (business.eventPhotos.isNotEmpty)
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: business.eventPhotos.length,
                      itemBuilder: (context, index) {
                        final photo = business.eventPhotos[index];
                        return Container(
                          width: 393,
                          height: 84*5,
                          child: photo.startsWith('http')
                              ? Image.network(
                            photo,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(photo),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  if (business.eventPhotos.isEmpty)
                    Center(
                      child: Text('No event images selected'),
                    ),
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
