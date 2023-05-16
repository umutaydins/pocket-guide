import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD:lib/pages/home_page.dart
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
=======
class logoutkismi extends StatelessWidget {

  logoutkismi({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;



  //Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
>>>>>>> dev:lib/dahasonrasicin.dart


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD:lib/pages/home_page.dart
        title: Text('Home Page'),
      ),
    );
  }
}
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//   final user = FirebaseAuth.instance.currentUser!;

//   HomePage({Key? key}) : super(key: key);

//   //Sign user out method
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),

//         actions: [
//           IconButton(
//             onPressed: signUserOut,
//             icon: const Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Center(
//         child: Text(
//           'Logged In As: ' + user.email!,
//           style: const TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
=======

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
>>>>>>> dev:lib/dahasonrasicin.dart
