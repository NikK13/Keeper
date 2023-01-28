import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:keeper/domain/utils/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/preferences.dart';
import '../../domain/utils/constants.dart';
import '../../domain/utils/localization.dart';
import '../../domain/utils/styles.dart';

class PreferenceProvider extends ChangeNotifier {
  SharedPreferences? sp;

  String? currentTheme;
  int? currentColorIndex;

  Locale? locale;
  bool? isFirst;
  bool? is24HourFormat;

  PackageInfo? packageInfo;

  PreferenceProvider() {
    _loadFromPrefs();
    if(packageInfo == null) {
      PackageInfo.fromPlatform().then((value) => packageInfo = value);
    }
  }

  _initPrefs() async {
    sp ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (sp!.getString(keyThemeMode) == null) await sp!.setString(keyThemeMode, "system");
    if (sp!.getBool(keyIsFirst) == null) await sp!.setBool(keyIsFirst, true);
    if (sp!.getString(keyLanguage) == null) {
      if(App.supportedLanguages.contains(window.locale.languageCode)){
        locale = Locale(window.locale.languageCode, '');
      }
      else{
        locale = const Locale('en', '');
      }
    } else {
      locale = Locale(sp!.getString(keyLanguage)!, '');
    }
    isFirst = sp!.getBool(keyIsFirst);
    is24HourFormat = sp!.getBool(key24Hour);
    currentTheme = sp!.getString(keyThemeMode);
    currentColorIndex = sp!.getInt(keyColorIndex) ?? 0;
    notifyListeners();
  }

  savePreference(String key, value) async {
    await _initPrefs();
    final Map<String, Function> savesMap = {
      keyThemeMode: (){
        sp!.setString(key, value);
        currentTheme = sp!.getString(keyThemeMode);
      },
      keyColorIndex: (){
        sp!.setInt(key, value);
        currentColorIndex = sp!.getInt(keyColorIndex);
      },
      key24Hour: (){
        sp!.setBool(key, value);
        is24HourFormat = sp!.getBool(key24Hour);
      },
      keyLanguage: (){
        sp!.setString(key, value);
        locale = Locale(sp!.getString(keyLanguage)!, '');
      },
      keyIsFirst: (){
        sp!.setBool(key, value);
        isFirst = sp!.getBool(keyIsFirst);
      }
    };
    savesMap.entries.firstWhere((element) => element.key == key).value.call();
    notifyListeners();
  }

  void changeOsUI(){
    isIosApplication = !isIosApplication;
    notifyListeners();
  }

  void switchThemes(){
    if(currentTheme == "system"){
      savePreference(keyThemeMode, "dark");
    }
    else if(currentTheme == "dark"){
      savePreference(keyThemeMode, "light");
    }
    else{
      savePreference(keyThemeMode, "system");
    }
  }

  Future<void> deleteAllData() async{
    sp!
      ..remove(keyIsFirst)
      ..remove(key24Hour)
      ..remove(keyThemeMode)
      ..remove(keyLanguage);
    notifyListeners();
    await _loadFromPrefs();
  }

  static bool is24HourFormatFromLocale(Locale locale){
    final Map<String, bool> map = Map.fromEntries(App.supportedLanguages.map((lang){
      final is24hFormat = App.locales24h.contains(lang);
      return MapEntry(lang, is24hFormat);
    }));
    return map.entries.firstWhere((element) =>
    element.key == locale.languageCode).value;
  }

  ThemingMode get theme => ThemingMode(
    themeMode: getThemeMode(currentTheme!),
    accentColor: appColors[currentColorIndex!].accentColor,
    isDarkForAccent: appColors[currentColorIndex!].isDarkForAccent
  );

  Preferences get preferences => Preferences(
    locale: locale,
    isFirst: isFirst,
    theme: currentTheme,
    is24Hour: is24HourFormat,
  );

  String? getThemeTitle(BuildContext context) {
    final themesMap = {
      "light": AppLocalizations.of(context, 'theme_light'),
      "dark": AppLocalizations.of(context, 'theme_dark'),
      "system": AppLocalizations.of(context, 'theme_system')
    };
    return themesMap.entries.firstWhere((element) => element.key == sp!.getString(keyThemeMode)).value;
  }

  List<DesignColor> get appColors => List.from([
    DesignColor(
      accentColor: const Color(0xFF21C51F),
      isDarkForAccent: false
    ),
    DesignColor(
      accentColor: const Color(0xFFFCC705),
      isDarkForAccent: true
    ),
    DesignColor(
      accentColor: const Color(0xFF4C2AF1),
      isDarkForAccent: false
    ),
    DesignColor(
      accentColor: const Color(0xFFE02B2B),
      isDarkForAccent: false
    ),
    DesignColor(
      accentColor: const Color(0xFF1FA668),
      isDarkForAccent: false
    ),
    DesignColor(
      accentColor: const Color(0xFFFF6B00),
      isDarkForAccent: true
    ),
    DesignColor(
      accentColor: const Color(0xFF2259F2),
      isDarkForAccent: false
    ),
    DesignColor(
      accentColor: const Color(0xFFB2EE32),
      isDarkForAccent: true
    ),
    DesignColor(
      accentColor: const Color(0xFFE85CBC),
      isDarkForAccent: false
    ),
  ]);
}

class ThemingMode{
  Color? accentColor;
  bool? isDarkForAccent;
  ThemeMode? themeMode;

  ThemingMode({
    this.themeMode,
    this.accentColor,
    this.isDarkForAccent
  });
}

class DesignColor{
  Color? accentColor;
  bool? isDarkForAccent;

  DesignColor({
    this.accentColor,
    this.isDarkForAccent
  });
}