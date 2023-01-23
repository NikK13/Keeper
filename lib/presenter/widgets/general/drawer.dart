// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/nested/nested_delegate.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/domain/utils/app.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:keeper/domain/utils/localization.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final HomePageBloc? bloc;
  final String? location;
  final Function? onTabChanged;
  final NestedRouterDelegate? nestedDelegate;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawer({
    Key? key,
    this.bloc,
    this.location,
    this.nestedDelegate,
    this.onTabChanged,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //debugPrint("DRAWER - $location");
    return WillPopScope(
      onWillPop: () async{
        if(defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android){
          debugPrint("DRAWER_WillPopScope");
          scaffoldKey.currentState?.closeDrawer();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.62,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                curve: Curves.slowMiddle,
                duration: const Duration(
                  milliseconds: 0
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 45, height: 45,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          App.appName,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            if(kDebugMode){
                              final provider = Provider.of<PreferenceProvider>(context, listen: false);
                              provider.deleteAllData();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context, 'desc'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: drawerItems(context, location!)
              ),
              const Divider(),
              DrawerItemView(
                item: DrawerItem(
                  icon: CupertinoIcons.settings,
                  location: AppRoutes.settingsPath,
                  title: AppLocalizations.of(context, 'settings'),
                  onPressed: () async{
                    context.push(AppRoutes.settingsPath);
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DrawerItem> drawerItemsList(BuildContext context) => List.from([
    DrawerItem(
      icon: Icons.sticky_note_2_outlined,
      location: NestedRoutes.notesPath,
      title: AppLocalizations.of(context, 'notes'),
    ),
    DrawerItem(
      icon: Icons.task_alt,
      location: NestedRoutes.tasksPath,
      title: AppLocalizations.of(context, 'tasks'),
    ),
    /*DrawerItem(
      icon: Icons.event_note_outlined,
      location: NestedRoutes.eventsPath,
      title: AppLocalizations.of(context, 'events'),
    ),*/
    DrawerItem(
      icon: Icons.event_note_outlined,
      location: NestedRoutes.remindersPath,
      title: AppLocalizations.of(context, 'reminders'),
    ),
  ]);

  List<Widget> drawerItems(BuildContext context, String curLoc) => List.generate(
    drawerItemsList(context).length,
    (index) => DrawerItemView(
      bloc: bloc,
      location: curLoc,
      scaffoldKey: scaffoldKey,
      onTabChanged: onTabChanged,
      item: drawerItemsList(context)[index],
      navigateTo: (){
        if(curLoc != drawerItemsList(context)[index].location){
          nestedDelegate!.nestedRouteConfig = drawerItemsList(context)[index].location;
        }
      },
    )
  );
}

class DrawerItemView extends StatelessWidget {
  final DrawerItem item;
  final HomePageBloc? bloc;
  final String? location;
  final Function? navigateTo;
  final Function? onTabChanged;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DrawerItemView({
    Key? key,
    this.bloc,
    this.location,
    this.scaffoldKey,
    this.navigateTo,
    this.onTabChanged,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return GestureDetector(
      onTap: item.onPressed != null ?
      () => item.onPressed!() : (){
        if(location != null){
          scaffoldKey?.currentState?.closeDrawer();
          if(bloc != null){
            bloc!
            ..changeFABState(true)
            ..changeSearchState(false)
            ..changeCurrentLocation(item.location);
          }
          if(onTabChanged != null) onTabChanged!();
          if(navigateTo != null) navigateTo!();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(8.0),
        /*decoration: BoxDecoration(
          color: location != null ?
          location == item.location ?
          provider.theme.accentColor!.withOpacity(0.2):
          Colors.transparent : Colors.transparent,
          borderRadius: BorderRadius.circular(16)
        ),*/
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 28,
                color: location != null ?
                location == item.location ?
                provider.theme.accentColor:
                accent(context) : accent(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: location != null ?
                    location == item.location ?
                    FontWeight.w700 : FontWeight.w500
                    : FontWeight.w500,
                    color: location != null ?
                    location == item.location ?
                    provider.theme.accentColor:
                    accent(context) : accent(context),
                    //letterSpacing: 0.65
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem{
  final String title;
  final IconData icon;
  final String location;
  final Function? onPressed;

  const DrawerItem({
    this.onPressed,
    required this.icon,
    required this.title,
    required this.location,
  });
}

