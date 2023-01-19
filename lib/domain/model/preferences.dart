import 'package:flutter/material.dart';

class Preferences {
  String? theme;
  Locale? locale;
  bool? is24Hour;
  bool? isFirst;

  Preferences({
    required this.theme,
    required this.locale,
    required this.isFirst,
    required this.is24Hour
  });
}