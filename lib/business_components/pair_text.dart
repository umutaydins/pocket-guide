import 'package:flutter/material.dart';

class TitleTextPair extends StatelessWidget {
  final String title;
  final String text;

  const TitleTextPair({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
      ],
    );
  }
}
