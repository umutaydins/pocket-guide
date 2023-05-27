import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoverPhotoSlider extends StatefulWidget {
  final List<String> coverPhotos;

  CoverPhotoSlider({required this.coverPhotos});

  @override
  _CoverPhotoSliderState createState() => _CoverPhotoSliderState();
}

class _CoverPhotoSliderState extends State<CoverPhotoSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.coverPhotos.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(widget.coverPhotos[index]);
          },
        ),
        // Positioned(
        //   top: MediaQuery.of(context).padding.top + 16,
        //   left: 16,
        //   child: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       setState(() {
        //         if (_currentIndex > 0) {
        //           _currentIndex--;
        //         }
        //       });
        //     },
        //   ),
        // ),
        // Positioned(
        //   top: MediaQuery.of(context).padding.top + 16,
        //   right: 16,
        //   child: IconButton(
        //     icon: Icon(Icons.arrow_forward),
        //     onPressed: () {
        //       setState(() {
        //         if (_currentIndex < widget.coverPhotos.length - 1) {
        //           _currentIndex++;
        //         }
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class YourPage extends StatelessWidget {
  final String userId;

  YourPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('businesses')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final coverPhotos = List<String>.from(data['cover_photos']);

        return CoverPhotoSlider(coverPhotos: coverPhotos);
      },
    );
  }
}
