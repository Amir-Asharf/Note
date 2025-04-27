import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mylocalecontroller extends GetxController {
  Locale? initialLang;
  bool isDarkMode = false;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  // تحميل اللغة المحفوظة
  Future<void> loadSavedLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? langCode = prefs.getString('langCode');

      if (langCode != null) {
        print('تم تحميل اللغة المحفوظة: $langCode');
        initialLang = Locale(langCode);
        Get.updateLocale(initialLang!);
      } else {
        print('لم يتم العثور على لغة محفوظة، استخدام لغة الجهاز');
        initialLang = Get.deviceLocale;
        if (initialLang == null) {
          initialLang = const Locale('en');
        }
        Get.updateLocale(initialLang!);
      }

      // تحميل حالة الثيم
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _updateTheme();
    } catch (e) {
      print('خطأ في تحميل اللغة: $e');
      initialLang = const Locale('en');
      Get.updateLocale(initialLang!);
    }
  }

  // تغيير اللغة
  Future<void> changeLang(String langCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('langCode', langCode);

      initialLang = Locale(langCode);
      Get.updateLocale(initialLang!);

      print('تم تغيير اللغة إلى: $langCode');
    } catch (e) {
      print('خطأ في تغيير اللغة: $e');
    }
  }

  // تبديل الثيم
  Future<void> toggleDarkMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isDarkMode = !isDarkMode;
      await prefs.setBool('isDarkMode', isDarkMode);
      _updateTheme();
    } catch (e) {
      print('خطأ في تغيير الثيم: $e');
    }
  }

  // تحديث الثيم
  void _updateTheme() {
    if (isDarkMode) {
      Get.changeTheme(Themes.customDarkTheme);
    } else {
      Get.changeTheme(Themes.customLightTheme);
    }
  }
}

class Themes {
  static final ThemeData customDarkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );

  static final ThemeData customLightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 0, 174, 255),
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color.fromARGB(255, 0, 174, 255),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );
}
