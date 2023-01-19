import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/config.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/presenter/ui/home.dart';
import 'package:keeper/presenter/ui/settings.dart';

import '../../presenter/bloc/home_bloc.dart';

class AppRouterDelegate extends RouterDelegate<AppRouteConfig> with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final _navigatorStack = <Page>[];

  late HomePageBloc _homePageBloc;

  AppRouteConfig? _routeConfig;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>(){
    _homePageBloc = HomePageBloc();
    _routeConfig = AppRouteConfig(location: AppRoutes.homePath);
    if(!kIsWeb){
      _navigatorStack.add(MaterialPage(child: pagesMap()[AppRoutes.homePath]!));
    }
  }

  @override
  Future<void> setNewRoutePath(AppRouteConfig configuration) async{
    _routeConfig = AppRouteConfig(
      location: configuration.location,
      extras: configuration.extras
    );
  }

  @override
  AppRouteConfig get currentConfiguration => AppRouteConfig(
    location: _routeConfig!.location,
    extras: _routeConfig!.extras
  );

  Future replace(String location, [Map<String, dynamic>? extras]) async{
    _navigatorStack.clear();
    _navigatorStack.add(MaterialPage(child: pagesMap(extras)[location]!));
    notifyListeners();
  }

  Future push(String location, [Map<String, dynamic>? extras]) async{
    if(!kIsWeb){
      _navigatorStack.add(MaterialPage(child: pagesMap(extras)[location]!));
    }
    _routeConfig = AppRouteConfig(location: location, extras: extras);
    notifyListeners();
  }

  Future pop() async {
    _navigatorStack.removeLast();
    notifyListeners();
  }

  bool remove(Page page) {
    final index = _navigatorStack.indexOf(page);
    if (index == -1) {
      return false;
    }
    _navigatorStack.remove(page);
    return true;
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    remove(route.settings as Page);
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: kIsWeb ? [
        /*if(_routeConfig!.location == AppRoutes.homePath)
          MaterialPage(child: pagesMap()[AppRoutes.homePath]!),
        if(_routeConfig!.location == AppRoutes.settingsPath)
          MaterialPage(child: pagesMap()[AppRoutes.settingsPath]!)*/
        MaterialPage(child: pagesMap(_routeConfig!.extras)[_routeConfig!.location]!)
      ] : List.unmodifiable(
        _navigatorStack
      ),
      onPopPage: _onPopPage,
    );
  }

  Map<String, Widget> pagesMap([Map<String, dynamic>? extras]) => {
    AppRoutes.homePath: HomePage(homePageBloC: _homePageBloc),
    AppRoutes.settingsPath: const SettingsPage()
  };
}