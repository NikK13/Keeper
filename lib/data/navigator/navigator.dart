import 'package:flutter/material.dart';

class AppNavigator{
  late GlobalKey<NavigatorState> globalNavigatorKey;
  late GlobalKey<NavigatorState> nestedNavigatorKey;

  static AppNavigator instance = AppNavigator();

  AppNavigator(){
    globalNavigatorKey = GlobalKey<NavigatorState>();
    nestedNavigatorKey = GlobalKey<NavigatorState>();
    debugPrint("AppNavigator init..");
  }

  BuildContext get globalContext => globalNavigatorKey.currentContext!;
}