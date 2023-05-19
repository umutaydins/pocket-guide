// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pocket_guide/components/my_button.dart';
// import 'package:pocket_guide/components/square_tile.dart';
// import 'package:pocket_guide/components/my_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_guide/signInOutAndAppPage/app_page.dart';
import 'package:pocket_guide/registerPages/bussinesRegisterPages/bussines_register.dart';
import 'package:pocket_guide/signInOutAndAppPage/login_page.dart';
import '../registerPages/userRegisterPage/user_register.dart';
import '../registerPages/bussinesRegisterPages/bussines_register.dart';

import '../components/colors.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _selectedUser = true;
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    UserRegisterPage(), // replace this with UserRegisterW
    BusinessRegisterPage(), // replace this with BusinessRegisterW
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 71, left: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 345,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedUser = true;
                        _selectedPageIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      primary: _selectedUser
                          ? MyColors.primaryColor
                          : MyColors.backGroundkColor,
                      onPrimary: _selectedUser ? Colors.white : Colors.white,
                      side: BorderSide(
                          color: Colors.white,
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(48),
                                bottomLeft: Radius.circular(48),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'User',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedUser = false;
                                _selectedPageIndex = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(48),
                                  bottomRight: Radius.circular(48),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              primary: _selectedUser
                                  ? MyColors.backGroundkColor
                                  : MyColors.primaryColor,
                              onPrimary:
                                  _selectedUser ? Colors.white : Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(48),
                                  bottomRight: Radius.circular(48),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Business',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   width: 170,
                  //   height: 40,

                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _selectedUser = false;
                  //         _selectedPageIndex = 1;
                  //       });
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.only(
                  //           topRight: Radius.circular(48),
                  //           bottomRight: Radius.circular(48),
                  //         ),
                  //       ),
                  //       padding: EdgeInsets.zero,
                  //       elevation: 0,
                  //       primary: _selectedUser ? MyColors.backGroundkColor : MyColors.primaryColor,
                  //       onPrimary: _selectedUser ? Colors.white : Colors.white,
                  //       side: BorderSide(color: Colors.white, width: 0, style: BorderStyle.solid),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'Business',
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: 100,
                  // )
                ),
              ],
            ),
            Expanded(child: _pages[_selectedPageIndex]),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already  have an account?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login Now',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class RegisterPage extends StatefulWidget {
//   final Function()? onTap;

//   const RegisterPage({
//     Key? key,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool _selectedUser = true;
//   int _selectedPageIndex = 0;

//   final List<Widget> _pages = [
//     Placeholder(color: MyColors.backGroundkColor), // replace this with UserRegisterW
//     Placeholder(color: Colors.blue), // replace this with BusinessRegisterW
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColors.backGroundkColor,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 170,
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _selectedUser = true;
//                     _selectedPageIndex = 0;
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(48),
//                       bottomLeft: Radius.circular(48),
//                     ),
//                   ),
//                   padding: EdgeInsets.zero,
//                   elevation: 0,
//                   primary: _selectedUser ? MyColors.primaryColor : MyColors.backGroundkColor,
//                   onPrimary: _selectedUser ? Colors.white : Colors.white,
//                   side: BorderSide(color: Colors.white, width: 0, style: BorderStyle.solid),
                
//                 ),
//                 child: Center(
//                   child: Text(
//                     'User',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 170,
//               child: ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _selectedUser = false;
//                     _selectedPageIndex = 1;
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(48),
//                       bottomRight: Radius.circular(48),
//                     ),
//                   ),
//                   padding: EdgeInsets.zero,
//                   elevation: 0,
//                   primary: _selectedUser ? MyColors.backGroundkColor : MyColors.primaryColor,
//                   onPrimary: _selectedUser ? Colors.white : Colors.white,
//                   side: BorderSide(color: Colors.white, width: 0, style: BorderStyle.solid),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Business',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _pages[_selectedPageIndex]),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Already  have an account?',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 const SizedBox(
//                   width: 4,
//                 ),
               

//                 GestureDetector(
//                   onTap:widget.onTap, // replace this with your function
//                   child: const Text(
//                     'Login Now',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 4,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

      










































// class RegisterPage extends StatefulWidget {
//    final Function()? onTap;
//    const RegisterPage({
//     super.key,
//     required this.onTap,
//     }
//     );


//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _surnameController = TextEditingController();
//   final _birthdayController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _tagsController = TextEditingController();

//   bool _isBusinessUser = false;

//   List<String> _tags = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Register"),
//         ),
//         body: Form(
//           key: _formKey,
//           child: ListView(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: "Name",
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter your name";
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _surnameController,
//                 decoration: InputDecoration(
//                   labelText: "Surname",
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter your surname";
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _birthdayController,
//                 decoration: InputDecoration(
//                   labelText: "Birthday",
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter your birthday";
//                   }
//                   return null;
//                 },
//               ),
             
             
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter your email";
//                   }
//                   return null;
//                 },
//               ),
             
             
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Please enter your password";
//                   }
//                   return null;
//                 },
//               ),
            
            
//              CheckboxListTile(
//                 title: Text("Business User"),
//                 value: _isBusinessUser,
//                 onChanged: (value) {
//                    setState(() {
//                 _isBusinessUser = value ?? false;
//                 });
//                 },
//               ),
              
              
//               Visibility(
//                 visible: _isBusinessUser,
//                 child: TextFormField(
//                   controller: _tagsController,
//                   decoration: InputDecoration(
//                     labelText: "Tags",
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       _tags = value.split(",");
//                     });
//                   },
//                 ),
//               ),
              
//               ElevatedButton(
//                 child: Text("Register"),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     try {
//                       final auth = FirebaseAuth.instance;
//                       final email = _emailController.text.trim();
//                       final password = _passwordController.text.trim();
//                       final result = await auth.createUserWithEmailAndPassword(
//                         email: email,
//                         password: password,
//                       );
//                       final firestoreInstance = FirebaseFirestore.instance;
//                       final user = FirebaseAuth.instance.currentUser;
//                       await firestoreInstance
//                           .collection("users")
//                           .doc(user?.uid)///???
//                           .set({
//                         "name": _nameController.text,
//                         "surname": _surnameController.text,
//                         "birthday": _birthdayController.text,
//                         "email": _emailController.text,
//                         "isBusinessUser": _isBusinessUser,
//                         "tags": _tags,
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Registered successfully!"),
//                         ),
//                       );

//                       Navigator.pop(context);
//                        } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Registration failed. "), //{e.message}
//                         ),
//                       );
//                     }
//                   }
//                 },
//               ),
//                Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Already  have an account?',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: const Text(
//                         'Login Now',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                       ),
//                    ],
//                   )
//             ],
//           ),
//         ));
//   }
// }

        
                  
                      


      
                
      
   
























// Firebase Authentication hes
// class RegisterPage extends StatefulWidget {
//   final Function()? onTap;

//   const RegisterPage({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   //Text editingControllers

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   //sign user up method
//   void signUserUp() async {
//     //show loading circle
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );

//     //try create user
//     try {
//       //check if password is confirmed
//       if (passwordController.text == confirmPasswordController.text) {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//             email: emailController.text, password: passwordController.text);
//       } else {
//         //show error message, password dont match
//         showErrorMessage("Passwords don't match");
//       }
//     } on FirebaseAuthException catch (e) {
//       //pop the loading circle
//       Navigator.pop(context);

//       // //wrong email
//       // if (e.code == 'user-not-found') {
//       //   //show error to user
//       //   wrongEmailMassage();
//       // } else if (e.code == 'wrong-password') {
//       //   //show error to user
//       //   wrongPasswordMassage();
//       // }
//       // show error massage
//       showErrorMessage(e.code);
//     }
//   }

//   // error massage to user
//   void showErrorMessage(String message) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Colors.deepPurple,
//             title: Center(
//               child: Text(
//                 message,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           );
//         });
//   }

//   //wrong password massage popup
//   // void wrongPasswordMassage() {
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return const AlertDialog(
//   //           title: Text('Wrong password provided for that user'),
//   //         );
//   //       });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orangeAccent,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 25),

//                 //logo
//                 const Icon(
//                   Icons.lock,
//                   size: 50,
//                 ),

//                 const SizedBox(
//                   height: 25,
//                 ),

//                 //Let's create an account for you!

//                 Text('Let\'s create an account for you!',
//                     style: TextStyle(color: Colors.grey[700], fontSize: 16)),
//                 const SizedBox(
//                   height: 25,
//                 ),

//                 //username text-field
//                 MyTextField(
//                   controller: emailController,
//                   hintText: 'Username',
//                   obsourceText: false,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),

//                 //password text-field
//                 MyTextField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   obsourceText: true,
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),

//                 //confirm password text-field
//                 MyTextField(
//                   controller: confirmPasswordController,
//                   hintText: 'Confirm Password',
//                   obsourceText: true,
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),
//                 //forgot password
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         ''
//                         'Forgot Password?',
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),

//                 //sign up button
//                 MyButton(text: 'Sign Up', onTap: signUserUp),

//                 const SizedBox(
//                   height: 50,
//                 ),

//                 //or continue with
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 0.5,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Text(
//                           'Or continue with',
//                           style: TextStyle(color: Colors.grey[700]),
//                         ),
//                       ),
//                       Expanded(
//                         child: Divider(
//                           thickness: 0.5,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 50),

//                 //google + apple sign buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     //   google button

//                     SquareTile(imagePath: 'lib/images/google.png'),

//                     SizedBox(
//                       width: 25,
//                     ),

//                     //   apple button

//                     SquareTile(imagePath: 'lib/images/apple.png'),
//                   ],
//                 ),

//                 const SizedBox(
//                   height: 50,
//                 ),

//                 //not a member? register now
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Already  have an account?',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: const Text(
//                         'Login Now',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
