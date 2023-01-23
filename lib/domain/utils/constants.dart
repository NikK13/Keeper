import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isIosApplication = defaultTargetPlatform == TargetPlatform.iOS;

const numberTypeForInputs = TextInputType.numberWithOptions(decimal: true);

const String androidPl = "android";
const String iosPl = "iOS";

const String dateFormat24h = "dd/MM/yyyy kk:mm";
const String dateFormat12h = "dd/MM/yyyy hh:mma";
const String dateFormat = "dd/MM/yyyy";

const String notesType = "note";
const String tasksType = "tasks";
const String reminderType = "reminder";

const String key24Hour = "24h";
const String keyThemeMode = "mode";
const String keyLanguage = "language";
const String keyIsFirst = "first";
const String keyColorIndex = "color_index";