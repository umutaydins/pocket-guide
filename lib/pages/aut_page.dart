import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocket_guide/pages/login_or_register.dart';
import 'package:pocket_guide/pages/login_page.dart';

import 'app_page.dart';
import 'home_page.dart';

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
            return AppPage();
          }

          //user is  NOT logged in
          else {

            return const LoginOrRegisterPage();

            return LoginOrRegisterPage();

          }
        },
      ),
    );
  }
}
