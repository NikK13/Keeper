import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/app.dart';
import '../../provider/provider.dart';

class AppPage extends StatelessWidget{
  final Widget child;
  final Widget? drawer;
  final Widget? bottomNavBar;
  final Widget? floatingActionButton;
  final EdgeInsets? padding;
  final GlobalKey? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final bool resizePageWhenKeyboard;
  final bool isCurrentPageMain;
  final bool isWithBottomNav;
  final bool bottomSafeArea;
  final bool topSafeArea;

  const AppPage({
    Key? key,
    this.appBar,
    this.drawer,
    this.padding,
    this.scaffoldKey,
    this.bottomNavBar,
    required this.child,
    this.floatingActionButton,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
    this.isWithBottomNav = false,
    this.isCurrentPageMain = false,
    this.resizePageWhenKeyboard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      appBar: appBar,
      key: scaffoldKey,
      resizeToAvoidBottomInset: resizePageWhenKeyboard,
      body: AnnotatedRegion(
        value: App.themedOverlayStyle(provider.currentTheme, context, isWithBottomNav),
        child: SafeArea(
          maintainBottomViewPadding: true,
          top: topSafeArea,
          bottom: bottomSafeArea,
          child: Padding(
            padding: padding ?? App.appPadding,
            child: SizedBox(height: double.infinity, child: child),
          ),
        ),
      ),
      drawer: drawer,
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
