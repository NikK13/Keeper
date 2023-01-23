import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/config.dart';
import 'package:keeper/data/navigator/navigator.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/presenter/ui/home.dart';
import 'package:keeper/presenter/ui/note_view_page.dart';
import 'package:keeper/presenter/ui/settings.dart';

class AppRouterDelegate extends RouterDelegate<AppRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteConfig>{
  @override
  GlobalKey<NavigatorState> get navigatorKey => AppNavigator.instance.globalNavigatorKey;

  final _navigatorStack = <Page>[];

  AppRouteConfig? _routeConfig;

  AppRouterDelegate(){
    debugPrint("AppRouterDelegate init..");
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
  AppRouteConfig get currentConfiguration => _routeConfig!;

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
    if(_navigatorStack.length > 1){
      _navigatorStack.removeLast();
      notifyListeners();
    }
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
    //debugPrint("NAV: $_navigatorStack");
    return Navigator(
      key: navigatorKey,
      pages: kIsWeb ? [
        MaterialPage(child: pagesMap(_routeConfig!.extras)[_routeConfig!.location]!)
      ] : List.unmodifiable(_navigatorStack),
      onPopPage: _onPopPage,
    );
  }

  Map<String, Widget> pagesMap([Map<String, dynamic>? extras]) => {
    AppRoutes.homePath: const HomePage(),
    AppRoutes.settingsPath: const SettingsPage(),
    AppRoutes.noteViewPath: NoteViewPage(extras: extras)
  };
}