import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  void changelang(String lang) {
    var locale = Locale(lang);
    Get.updateLocale(locale);
  }
}
