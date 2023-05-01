import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
<<<<<<< HEAD
  const HomePage({Key? key}) : super(key: key);
=======
  final user = FirebaseAuth.instance.currentUser!;

  HomePage({Key? key}) : super(key: key);

  //Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
>>>>>>> master

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('Home Page'),
=======
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
>>>>>>> master
      ),
    );
  }
}