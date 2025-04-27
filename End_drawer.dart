import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notes_app/locale/locale_controller.dart';

class CustomEnddrawer extends StatelessWidget {
  final Mylocalecontroller controllerlang;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CustomEnddrawer({super.key}) : controllerlang = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.blue),
            title: Text("Account".tr),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "User Information".tr,
                    style: TextStyle(color: Colors.blue),
                  ),
                  content: FutureBuilder<User?>(
                    future: _auth.currentUser != null
                        ? Future.value(_auth.currentUser)
                        : Future.value(null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData) {
                        User? user = snapshot.data;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Text(
                                user!.displayName != null
                                    ? user.displayName![0]
                                    : "A",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              user.displayName ?? "اسم المستخدم غير متاح".tr,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              user.email ?? "البريد الإلكتروني غير متاح".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      } else {
                        return Center(child: Text("لم تقم بتسجيل الدخول".tr));
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Close".tr,
                          style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("login", (route) => false);
                      },
                      child: Text("Logout".tr,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(LucideIcons.globe, color: Colors.blue),
            title: Text("Language".tr),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Choose Language".tr,
                    style: TextStyle(color: Colors.blue),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        controllerlang.changeLang("ar");
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Arabic".tr,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controllerlang.changeLang("en");
                        Navigator.pop(context);
                      },
                      child: Text(
                        "English".tr,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.light_mode_outlined, color: Colors.blue),
            title: Text("Dark Mode".tr),
            onTap: () {
              final Mylocalecontroller controller = Get.find();
              controller.toggleDarkMode();
            },
          ),
        ],
      ),
    );
  }
}
