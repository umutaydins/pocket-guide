import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/components/colors.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: ListView(
            children: [
              logoField(context),
              midLogoAndText(context),
            ],
      ),
    );
  }
}
Widget logoField(BuildContext context){
  return Row(
    children: [
      Padding(padding: EdgeInsets.only(top: 162,left: 99)),
      SvgPicture.asset(
          'assets/icons/logo.svg'
      ),
      SizedBox(width: 9,),
      Text(
        'FEX',
        style: GoogleFonts.inter(
          fontSize: 48.0,
          fontWeight: FontWeight.w700,
          color: MyColors.thirdTextColor,
        ),
      ),
    ],
  );
}

Widget midLogoAndText(BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/icons/Illustration.svg'
      ),
      SizedBox(height: 41,),
      SvgPicture.asset(
          'assets/icons/text.svg'
      ),
    ],
  );
}

