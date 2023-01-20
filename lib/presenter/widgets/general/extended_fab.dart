import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';

class ExtendedFAB extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;

  const ExtendedFAB({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 6),
      child: FloatingActionButton.extended(
        icon: Icon(
          icon,
          size: 28,
          color: provider.theme.isDarkForAccent! ?
          Colors.black : Colors.white,
        ),
        label: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: provider.theme.isDarkForAccent! ?
            Colors.black : Colors.white
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        backgroundColor: provider.theme.accentColor,
        splashColor: Colors.transparent,
        onPressed: () => onPressed(),
      ),
    );
  }
}
