
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_guide/bussinessPage/business_AppPage.dart';
import 'package:pocket_guide/bussinessPage/business_HomePage.dart';
import 'package:pocket_guide/bussinessPage/postPage.dart';
import 'package:pocket_guide/registerPages/bussinesRegisterPages/bussines_register.dart';
import 'package:pocket_guide/registerPages/bussinesRegisterPages/bussiness_detailed_info.dart';
import '../firstLoginPage/entry.dart';
import 'app_page.dart';
import 'auth_user_business_page.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return BusinessHomePage();
          }
          //user is  NOT logged in
          else {
            return  BusinessHomePage();
          }
        },
      ),
    );
  }
}
