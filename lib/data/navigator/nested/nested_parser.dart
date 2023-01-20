import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/config.dart';

class NestedRouterParser extends RouteInformationParser<AppRouteConfig>{
  NestedRouterParser(){
    //debugPrint("NestedRouterParser INIT");
  }

  @override
  Future<AppRouteConfig> parseRouteInformation(RouteInformation routeInformation) async{
    final uri = Uri.parse(routeInformation.location!);
    //debugPrint("NESTED_parseRouteInformation: ${uri.path}");
    return AppRouteConfig(location: uri.path);
  }

  @override
  RouteInformation restoreRouteInformation(AppRouteConfig configuration) {
    //debugPrint("NESTED_restoreRouteInformation: ${configuration.location}");
    return RouteInformation(location: configuration.location);
  }
}