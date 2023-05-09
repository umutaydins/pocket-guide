import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_guide/components/my_button.dart';
import 'package:pocket_guide/components/square_tile.dart';
import 'package:pocket_guide/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text editingControllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user up method
  void signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try create user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        //show error message, password dont match
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      // //wrong email
      // if (e.code == 'user-not-found') {
      //   //show error to user
      //   wrongEmailMassage();
      // } else if (e.code == 'wrong-password') {
      //   //show error to user
      //   wrongPasswordMassage();
      // }
      // show error massage
      showErrorMessage(e.code);
    }
  }

  // error massage to user
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  //wrong password massage popup
  // void wrongPasswordMassage() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const AlertDialog(
  //           title: Text('Wrong password provided for that user'),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                //logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),

                const SizedBox(
                  height: 25,
                ),

                //Let's create an account for you!

                Text('Let\'s create an account for you!',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                const SizedBox(
                  height: 25,
                ),

                //username text-field
                MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obsourceText: false,
                ),
                const SizedBox(
                  height: 10,
                ),

                //password text-field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsourceText: true,
                ),

                const SizedBox(
                  height: 10,
                ),

                //confirm password text-field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obsourceText: true,
                ),

                const SizedBox(
                  height: 10,
                ),
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ''
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                //sign up button
                MyButton(text: 'Sign Up', onTap: signUserUp),

                const SizedBox(
                  height: 50,
                ),

                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                //google + apple sign buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //   google button

                    SquareTile(imagePath: 'lib/images/google.png'),

                    SizedBox(
                      width: 25,
                    ),

                    //   apple button

                    SquareTile(imagePath: 'lib/images/apple.png'),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),

                //not a member? register now
                Row(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
