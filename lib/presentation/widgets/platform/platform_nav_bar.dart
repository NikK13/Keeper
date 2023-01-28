import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../../domain/utils/extensions.dart';
import '../../../domain/utils/localization.dart';
import '../../../domain/utils/styles.dart';
import '../../provider/provider.dart';

class PlatformNavigationBar extends StatelessWidget {
  final int currentIndex;
  final int notificationsCount;
  final Function changeIndex;

  const PlatformNavigationBar({
    super.key,
    required this.changeIndex,
    required this.currentIndex,
    this.notificationsCount = 0
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return !isIosApplication ? Theme(
      data: ThemeData(
        useMaterial3: true,
        fontFamily: appFont,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: provider.theme.accentColor!,
          labelTextStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: accent(context)
          )),
          elevation: 0,
          backgroundColor: navigationBarColor(context),
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Theme.of(context).brightness == Brightness.light ? const Border(
            top: BorderSide(
              width: 0.175,
              color: Colors.black
            )
          ) : null
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => changeIndex(index),
          destinations: materialNavItems(context, provider, navBarItems(context)),
        ),
      ),
    ) : Theme(
      data: ThemeData(
        useMaterial3: true,
        fontFamily: appFont,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          selectedItemColor: provider.theme.accentColor,
          unselectedItemColor: colorNavUnselected,
          backgroundColor: navigationBarColor(context),
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Theme.of(context).brightness == Brightness.light ? const Border(
            top: BorderSide(
              width: 0.115,
              color: Colors.black
            )
          ) : null
        ),
        child: BottomNavigationBar(
          backgroundColor: navigationBarColor(context),
          onTap: (index) => changeIndex(index),
          iconSize: 28, currentIndex: currentIndex,
          selectedFontSize: 14, unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          items: iosNavItems(context, provider, navBarItems(context)),
        ),
      ),
    );
  }

  List<NavBarItem> navBarItems(BuildContext ctx) => [
    NavBarItem(
      label: AppLocalizations.of(ctx, 'tasks'),
      icon: Icons.check_outlined,
      activeIcon: Icons.check_box,
      iconSize: isIosApplication ? 32 : 28
    ),
    NavBarItem(
      label: AppLocalizations.of(ctx, 'keeper'),
      icon: Icons.sticky_note_2_outlined,
      activeIcon: Icons.sticky_note_2,
      iconSize: isIosApplication ? 32 : 28
    ),
    NavBarItem(
      label: AppLocalizations.of(ctx, 'reminders'),
      icon: Icons.notifications_active_outlined,
      activeIcon: Icons.notifications_active,
      iconSize: isIosApplication ? 32 : 28
    ),
  ];

  List<Widget> materialNavItems(context, provider, List<NavBarItem> list) => List.generate(
    list.length,
    (index) => NavigationDestination(
      icon: Icon(
        currentIndex == index ?
        list[index].activeIcon :
        list[index].icon,
        color: bottomBarIconColor(context, currentIndex, index, provider.theme.isDarkForAccent),
        size: list[index].iconSize,
      ),
      label: list[index].label
    )
  );

  List<BottomNavigationBarItem> iosNavItems(context, provider, List<NavBarItem> list) => List.generate(
    list.length,
    (index) => BottomNavigationBarItem(
      icon: Icon(
        list[index].icon,
        size: list[index].iconSize,
      ),
      activeIcon: Icon(
        list[index].activeIcon,
        size: list[index].iconSize,
      ),
      label: list[index].label
    ),
  );

  Widget notificationsBadge(int count) => Positioned(
    top: -3.5,
    right: isIosApplication ? -0.5 : 0,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle
      ),
      padding: const EdgeInsets.all(3.5),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: isIosApplication ? 10 : 9,
          color: Colors.white,
          fontWeight: FontWeight.w700
        ),
      ),
    ),
  );
}

class NavBarItem{
  String label;
  IconData icon;
  IconData activeIcon;
  double iconSize;

  NavBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.iconSize
  });
}
