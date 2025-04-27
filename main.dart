import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/categores/add.dart';
import 'package:notes_app/project/homebage.dart';
import 'package:notes_app/project/login.dart';
import 'package:notes_app/project/signup.dart';
import 'package:notes_app/locale/locale.dart';
import 'package:notes_app/locale/locale_controller.dart';
import 'package:notes_app/controllers/settings_controller.dart';
import 'package:notes_app/project/splash_screen.dart';
import 'package:notes_app/categores/edit.dart';
import 'package:notes_app/note/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(SettingsController());
  Get.put(Mylocalecontroller());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes App",
      locale: Get.find<Mylocalecontroller>().initialLang,
      fallbackLocale: const Locale("en"),
      translations: Mylocale(),
      theme: Themes.customLightTheme,
      darkTheme: Themes.customDarkTheme,
      themeMode: Get.find<SettingsController>().themeMode,
      home: SplashScreen(),
      routes: {
        "login": (context) => login(),
        "signup": (context) => signup(),
        "splash_screen": (context) => SplashScreen(),
        "homebage": (context) => homebage(),
        "Addcategory": (context) => Addcategory(),
        "EditCategory": (context) => EditCategory(
              docid: Get.arguments["docid"],
              oldname: Get.arguments["oldname"],
            ),
        "Noteview": (context) => Noteview(
              categoryid: Get.arguments["categoryid"],
            ),
      },
    );
  }
}

class Themes {
  static ThemeData customDarkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  );

  static ThemeData customLightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 0, 174, 255),
    ),
  );
}
