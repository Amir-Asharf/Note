import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app/components/textformfield.dart';
import 'package:path/path.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isloading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      serverClientId:
          "271765655815-gjiv3dceu3un32fjv0hlo8c7iihaags5.apps.googleusercontent.com",
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context as BuildContext).pushReplacementNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                                  borderRadius: BorderRadius.circular(80)),
                              child: Image.asset(
                                "images/unnamed.webp",
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                          const Text(
                            "login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          const Text(
                            "login to continue using the App",
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                            height: 20,
                          ),
                          const Text(
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
                          Container(
                            height: 10,
                          ),
                          const Text(
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
                          InkWell(
                            onTap: () async {
                              if (email.text == "") {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'error ',
                                        desc:
                                            'please write your email and click forgot password')
                                    .show();

                                return;
                              }

                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.rightSlide,
                                        title: 'confirm ',
                                        desc:
                                            'A Password reset message has been sent to your email. Please go to your email and change your password')
                                    .show();
                              } catch (e) {
                                AwesomeDialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'error ',
                                        desc:
                                            "Please check the email you entered")
                                    .show();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 20),
                              alignment: Alignment.topRight,
                              child: const Text(
                                "forgot password ?",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                            isloading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            isloading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "splash_screen", (route) => false);
                            } else {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.rightSlide,
                                      title: 'success ',
                                      titleTextStyle:
                                          TextStyle(color: Colors.black),
                                      descTextStyle:
                                          TextStyle(color: Colors.black),
                                      desc:
                                          'please go to your email and click activate account.')
                                  .show();
                            }
                          } on FirebaseAuthException catch (e) {
                            isloading = false;
                            setState(() {});
                            if (e.code == e.code) {
                              print('No user found for that email.');
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'error ',
                                      desc: 'No user found for that email.')
                                  .show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'error ',
                                desc: 'Wrong password provided for that user.',
                              ).show();
                            }
                          }
                        } else {
                          print("not valid");
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    const Text(
                      "OR Login with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      height: 40,
                      textColor: Colors.white,
                      color: Colors.black,
                      onPressed: () async {
                        try {
                          await signInWithGoogle();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "splash_screen", (route) => false);
                        } catch (e) {
                          print("Error signing in with Google: $e");
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Login with Google"),
                          ]),
                    ),
                    Container(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("signup");
                      },
                      child: const Center(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "Don't Have an account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "signup",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 174, 255),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold))
                        ])),
                      ),
                    )
                  ],
                ),
              ));
  }
}
