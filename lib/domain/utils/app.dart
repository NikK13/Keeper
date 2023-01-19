import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';
import 'styles.dart';

class App {
  static const String appName = "Keeper";
  static String platform = defaultTargetPlatform.name;

  static const appPadding = EdgeInsets.fromLTRB(10, 20, 10, 0);
  static const fragmentPadding = EdgeInsets.fromLTRB(12, 24, 12, 0);

  static List<String> get supportedLanguages => ["en", "ru"];

  static List<String> get locales24h => ["be", "ru", "ua"];

  static final Iterable<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultMaterialLocalizations.delegate,
    DefaultWidgetsLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  static final supportedLocales = List.generate(
    supportedLanguages.length,
    (index) => Locale(supportedLanguages[index], '')
  );

  static darkOverlayStyle(isNavigated) => SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: defaultTargetPlatform == TargetPlatform.iOS ?
    colorDark : (isNavigated ? colorNavDark : colorDark),
  );

  static lightOverlayStyle(isNavigated) => SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: const Color(0x00000000),
    systemNavigationBarColor: defaultTargetPlatform == TargetPlatform.iOS ?
    colorLight : (isNavigated ? colorNavLight : colorLight),
  );

  static SystemUiOverlayStyle themedOverlayStyle(mode, context, isNavigated){
    switch(mode){
      case 'light':
        return lightOverlayStyle(isNavigated);
      case 'dark':
        return darkOverlayStyle(isNavigated);
      default:
        return Theme.of(context).brightness == Brightness.light ?
        lightOverlayStyle(isNavigated) : darkOverlayStyle(isNavigated);
    }
  }
}
