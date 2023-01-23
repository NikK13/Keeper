import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/config.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/fragment/notes.dart';
import 'package:keeper/presenter/fragment/reminders.dart';
import 'package:keeper/presenter/fragment/tasks.dart';

import '../../../presenter/bloc/home_bloc.dart';

class NestedRouterDelegate extends RouterDelegate<AppRouteConfig> with ChangeNotifier{
  AppRouteConfig? _routeConfig;

  late final GlobalKey<NavigatorState> _nestedNavigatorKey;

  final Map<String, Page> _nestedPages = {};

  late final HomePageBloc _homePageBloc;
  late final DatabaseBloc _databaseBloc;

  NestedRouterDelegate(this._homePageBloc, this._databaseBloc) :_nestedNavigatorKey = GlobalKey<NavigatorState>(){
    debugPrint("NestedRouterDelegate init..");
    _routeConfig = AppRouteConfig(location: NestedRoutes.notesPath);
    _nestedPages[NestedRoutes.notesPath] = WithoutTransitionPage(
      key: const ValueKey(NestedRoutes.notesPath),
      child: getFragmentByLocation(NestedRoutes.notesPath)
    );
    _updateData(NestedRoutes.notesPath);
  }

  set nestedRouteConfig(String location){
    _routeConfig = AppRouteConfig(location: location);
    //setNewRoutePath(AppRouteConfig(location: location));
    if(!(_nestedPages.containsKey(location))){
      _nestedPages[location] = WithoutTransitionPage(
        key: ValueKey(location),
        child: getFragmentByLocation(location),
      );
    }
    _updateData(location);
    notifyListeners();
  }

  void _updateData(String location) async{
    switch(location){
      case NestedRoutes.notesPath:
        await _databaseBloc.getNotes();
        break;
      case NestedRoutes.tasksPath:
        await _databaseBloc.getTasks();
        break;
    }
  }

  AppRouteConfig get config => _routeConfig!;

  @override
  Future<void> setNewRoutePath(AppRouteConfig configuration) async{
    _routeConfig = configuration;
  }

  @override
  AppRouteConfig get currentConfiguration => _routeConfig!;

  Widget getFragmentByLocation(String location){
    switch(location){
      case NestedRoutes.notesPath:
        return NotesFragment(
          bloc: _homePageBloc,
          dbBloc: _databaseBloc,
        );
      case NestedRoutes.tasksPath:
        return TasksFragment(
          bloc: _homePageBloc,
          dbBloc: _databaseBloc,
        );
      case NestedRoutes.remindersPath:
        return const RemindersFragment();
      default:
        return NotesFragment(
          bloc: _homePageBloc,
          dbBloc: _databaseBloc,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("NAVIGATOR: $nestedNavigatorKey, ${_nestedPages.toString()}");
    return Navigator(
      key: _nestedNavigatorKey,
      pages: List.unmodifiable([
        _nestedPages.entries.firstWhere((element) =>
        element.key == _routeConfig!.location).value
      ]),
      onPopPage: (route, result){
        return route.didPop(result);
      },
    );
  }

  @override
  Future<bool> popRoute() async => false;
}

class WithoutTransitionPage extends Page {
  const WithoutTransitionPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.child,
  });

  final Widget child;

  @override
  Route createRoute(BuildContext context) => _WithoutTransitionPageRoute(this);
}

class _WithoutTransitionPageRoute extends PageRoute {
  _WithoutTransitionPageRoute(WithoutTransitionPage page) : super(settings: page);

  WithoutTransitionPage get _page => settings as WithoutTransitionPage;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;

  @override
  bool get opaque => true;

  @override
  Widget buildPage(context, animation, secondaryAnimation) => _page.child;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => child;
}
