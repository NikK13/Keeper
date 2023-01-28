import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../../domain/utils/styles.dart';
import '../../provider/provider.dart';

class PlatformAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final Widget? trailing;

  const PlatformAppBar({
    Key? key,
    this.trailing,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return isIosApplication ?
    CupertinoNavigationBar(
      brightness: getBrightnessByTheme(
        provider.currentTheme!,
        context
      ),
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).brightness == Brightness.light ?
            Colors.black : Colors.white,
            size: 21,
          ),
        ),
      ),
      backgroundColor: appBarColor(context),
      middle: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ?
          Colors.black : Colors.white,
          fontFamily: appFont,
          fontSize: 22
        ),
      ),
      trailing: trailing != null ? trailing! : null,
    ) : AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ?
          Colors.black : Colors.white,
          fontFamily: appFont,
          fontSize: 24
        ),
      ),
      shape: Theme.of(context).brightness == Brightness.light ? const Border(
        bottom: BorderSide(
          width: 0.115,
          color: Colors.black
        )
      ) : null,
      scrolledUnderElevation: 0,
      elevation: 0,
      actions: trailing != null ? [Padding(
        padding: const EdgeInsets.only(right: 16),
        child: trailing!,
      )] : null,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.light ?
            Colors.black : Colors.white,
            size: 26,
          ),
        ),
      ),
      backgroundColor: appBarColor(context),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    defaultTargetPlatform == TargetPlatform.iOS ? 55 : 60
  );
}
