import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/textformfield.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  // Future signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   Navigator.of(context).pushNamedAndRemoveUntil("homebage", (route) => false);
  // }

  // Future signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   if (googleUser == null) {
  //     return;
  //   }

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   Navigator.of(context).pushReplacementNamed("homebage");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 170,
                      height: 170,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Image.asset(
                        "images/unnamed.webp",
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  Text(
                    "signup",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "signup to continue using the App",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  customtextform(
                    hinttext: "Enter your username",
                    mycontroller: username,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  customtextform(
                    hinttext: "Enter your Email",
                    mycontroller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!val.contains("@") || !val.contains(".")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    "password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  customtextform(
                    hinttext: "Enter your password",
                    mycontroller: password,
                    isPassword: true,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (val.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              height: 40,
              textColor: Colors.black,
              color: Color.fromARGB(255, 0, 174, 255),
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  try {
            
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email.text, password: password.text);

                
                    await credential.user?.updateProfile(
                      displayName: username.text, 
                    );

                 
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();

                 
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "weak-password") {
                      print('the password provided is too weak.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'error ',
                        titleTextStyle: TextStyle(color: Colors.black),
                        descTextStyle: TextStyle(color: Colors.black),
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print(
                        'the account already exists for that email.',
                      );

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'error ',
                        titleTextStyle: TextStyle(color: Colors.black),
                        descTextStyle: TextStyle(color: Colors.black),
                        desc: 'The account already exists for that email.',
                      ).show();
                    }
                  } catch (e) {
                    print("Error: $e");
                  }
                }
              },
              child: Text(
                "signup",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              height: 15,
            ),
            Container(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              child: Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Have an account? ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "login",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 0, 174, 255),
                          fontWeight: FontWeight.bold))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
