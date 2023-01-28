import 'package:flutter/material.dart';

const String appFont = "Nunito";

const Color colorDark = Color(0xFF141414);
const Color colorLight = Color(0xFFFFFFFF);

//0xFF1F1F1F
const Color colorDarkSecondary = Color(0xFF1C1C1C);
const Color colorLightSecondary = Color(0xFFF9F9F9);
//0xFFF3F3F3

const Color colorNavDark = Color(0xFF191919);
const Color colorNavLight = Color(0xFFFFFFFF);
const Color colorNavUnselected = Color(0xFF8D8D8D);

const Color colorDialogDark = Color(0xFF141414);
const Color colorDialogLight = Color(0xFFFDFDFD);

const Color colorDrawerDark = Color(0xFF101010);
const Color colorDrawerLight = Color(0xFFFFFFFF);

const Color colorDrawerItemDark = Color(0xFF181818);
const Color colorDrawerItemLight = Color(0xFFFDFDFD);

const Color colorAppBarDark = Color(0xFF191919);
const Color colorAppBarLight = Color(0xFFFFFFFF);

Color get iconBackgroundColor => Colors.grey.withOpacity(0.1);

Color backgroundColor(context) => Theme.of(context).brightness == Brightness.light ? colorLight : colorDark;

Color navigationBarColor(context) => Theme.of(context).brightness == Brightness.light ?
colorNavLight : colorNavDark;

Color drawerColor(context) => Theme.of(context).brightness == Brightness.light ?
colorDrawerLight : colorDrawerDark;

Color drawerItemColor(context) => Theme.of(context).brightness == Brightness.light ?
colorDrawerItemLight : colorDrawerItemDark;

Color dialogBackgroundColor(context) => Theme.of(context).brightness == Brightness.light ?
colorDialogLight : colorDialogDark;

Color appBarColor(context) => Theme.of(context).brightness == Brightness.light ?
colorAppBarLight : colorAppBarDark;

Color secondaryColor(context) => Theme.of(context).brightness == Brightness.light ?
colorLightSecondary : colorDarkSecondary;

Color bottomBarIconColor(context, curIndex, barIndex, isDarkForAccent) => curIndex == barIndex ?
(isDarkForAccent ? Colors.black : Colors.white) : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;

const textStyleBtnLight = TextStyle(
  fontSize: 16,
  color: Colors.white
);

final textStyleBtnDark = TextStyle(
  fontSize: 16,
  color: Colors.green.shade700
);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: colorLight,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  useMaterial3: true,
  textTheme: const TextTheme(
    labelLarge: textStyleBtnLight,
  ),
  pageTransitionsTheme: themeTransitions,
  fontFamily: appFont,
  drawerTheme: const DrawerThemeData(
    elevation: 0,
    backgroundColor: colorDrawerLight
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 0.25
  ),
  colorScheme: const ColorScheme.light().copyWith(secondary: Colors.white),
);

ThemeData themeDark = ThemeData(
  scaffoldBackgroundColor: colorDark,
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  textTheme: TextTheme(
    labelLarge: textStyleBtnDark
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: appFont,
  pageTransitionsTheme: themeTransitions,
  drawerTheme: const DrawerThemeData(
    elevation: 0,
    backgroundColor: colorDrawerDark
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 0.25
  ),
  colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.black),
);

const themeTransitions = PageTransitionsTheme(
  builders: {
    //TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
  },
);

ThemeMode getThemeMode(String mode){
  switch(mode){
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

Brightness getBrightnessByTheme(mode, context){
  switch(mode){
    case 'light':
      return Brightness.light;
    case 'dark':
      return Brightness.dark;
    default:
      return Theme.of(context).brightness;
  }
}

