// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keeper/data/navigator/routes.dart';
import 'package:keeper/domain/utils/app.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:keeper/domain/utils/localization.dart';
import 'package:keeper/domain/utils/styles.dart';
import 'package:keeper/presenter/bloc/home_bloc.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final HomePageBloc? bloc;
  final String? location;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppDrawer({
    Key? key,
    this.bloc,
    this.location,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //debugPrint("DRAWER - $location");
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.625,
      child: Drawer(
        backgroundColor: drawerColor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
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
                  /*final info = await PackageInfo.fromPlatform();
                  context.push(AppRoutes.settingsPath, extra: {"info": info});*/
                },
              )
            ),
          ],
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
    DrawerItem(
      icon: Icons.event_note_outlined,
      location: NestedRoutes.eventsPath,
      title: AppLocalizations.of(context, 'events'),
    ),
    DrawerItem(
      icon: Icons.notifications_on_outlined,
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
      item: drawerItemsList(context)[index],
    )
  );
}

class DrawerItemView extends StatelessWidget {
  final DrawerItem item;
  final HomePageBloc? bloc;
  final String? location;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DrawerItemView({
    Key? key,
    this.bloc,
    this.location,
    this.scaffoldKey,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return GestureDetector(
      onTap: item.onPressed != null ?
      () => item.onPressed!() : () async{
        if(location != null){
          Navigator.pop(context);
          //scaffoldKey!.currentState!.closeDrawer();
          //await Future.delayed(const Duration(milliseconds: 1));
          if(bloc != null){
            bloc!
              ..changeFabState(true)
              ..changeSearchState(false)
              ..changeSelectedLocation(item.location);
          }
          context.go(item.location);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(8.0),
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
                    fontWeight: FontWeight.w600,
                    color: location != null ?
                    location == item.location ?
                    provider.theme.accentColor:
                    accent(context) : accent(context),
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

