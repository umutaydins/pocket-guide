import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_guide/bussinessPage/business_AppPage.dart';
import 'package:pocket_guide/registerPages/bussinesRegisterPages/bussiness_detailed_info.dart';
import 'package:pocket_guide/usersPages/user_app_page.dart';
import 'login_or_register.dart';

class AuthUserBusinessPage extends StatelessWidget {
  const AuthUserBusinessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.exists) {
                    return UserAppPage();
                  } else {
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('businesses')
                          .doc(user.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.exists) {
                            bool detailsCompleted =
                                snapshot.data!.get('detailsCompleted') ?? false;
                            if (detailsCompleted) {
                              return BusinessAppPage();
                            } else {
                              // return BusinessDetailedInformationPage();
                              return LoginOrRegisterPage();
                            }
                          } else {
                            return Text('No data found.');
                          }
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return CircularProgressIndicator();
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            );
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
