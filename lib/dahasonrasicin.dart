import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class logoutkismi extends StatelessWidget {

  logoutkismi({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;



  //Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Home Page'),

        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          'Logged In As: ' + user.email!,
          style: const TextStyle(fontSize: 20),

        ),
      ),
    );
  }
}