import 'package:flutter/material.dart';
import 'package:pocket_guide/components/colors.dart';

class EditInterests extends StatefulWidget {
  const EditInterests({Key? key}) : super(key: key);

  @override
  State<EditInterests> createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      appBar: AppBar(
        title: Text('Interests'),
      ),
    );
  }
}
