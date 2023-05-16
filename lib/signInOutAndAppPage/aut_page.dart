import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/pages/aut_page.dart
import 'package:pocket_guide/pages/app_page.dart';
import 'package:pocket_guide/pages/login_or_register.dart';
import 'package:pocket_guide/pages/login_page.dart';

import 'home_page.dart';
=======
import 'app_page.dart';
import 'auth_user_business_page.dart';
import 'login_or_register.dart';
>>>>>>> dev:lib/signInOutAndAppPage/aut_page.dart

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
<<<<<<< HEAD:lib/pages/aut_page.dart
            return AppPage();
=======
            return AuthUserBusinessPage();
>>>>>>> dev:lib/signInOutAndAppPage/aut_page.dart
          }
          //user is  NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
