import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxString _language = 'en'.obs;
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  late SharedPreferences _prefs;

  String get language => _language.value;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    // Load language
    _language.value = _prefs.getString('language') ?? 'en';
    Get.updateLocale(Locale(_language.value));

    // Load theme mode
    final savedThemeMode = _prefs.getString('theme_mode') ?? 'system';
    switch (savedThemeMode) {
      case 'light':
        _themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
        break;
      default:
        _themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setLanguage(String lang) async {
    _language.value = lang;
    await _prefs.setString('language', lang);
    Get.updateLocale(Locale(lang));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await _prefs.setString('theme_mode', modeString);
    Get.changeThemeMode(mode);
  }
}
