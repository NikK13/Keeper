import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/config.dart';

class AppRouterParser extends RouteInformationParser<AppRouteConfig>{
  @override
  Future<AppRouteConfig> parseRouteInformation(RouteInformation routeInformation) async{
    final uri = Uri.parse(routeInformation.location!);
    return AppRouteConfig(location: uri.path);
  }

  @override
  Future<AppRouteConfig> parseRouteInformationWithDependencies(RouteInformation routeInformation, BuildContext context) async{
    final uri = Uri.parse(routeInformation.location!);
    return AppRouteConfig(location: uri.path);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouteConfig configuration) {
    return RouteInformation(location: configuration.location);
  }
}