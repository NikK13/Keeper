import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../../domain/utils/styles.dart';
import '../../provider/provider.dart';

class PlatformButton extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Function()? onPressed;
  final Function? onLongPress;
  final double borderRadius;

  const PlatformButton({
    Key? key,
    @required this.text,
    this.fontSize = 18,
    @required this.onPressed,
    this.onLongPress,
    this.borderRadius = 50
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    if(isIosApplication) {
      return CupertinoButton(
        onPressed: onPressed!,
        color: provider.theme.accentColor,
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              fontFamily: appFont,
              color: provider.theme.isDarkForAccent! ?
              Colors.black : Colors.white,
            ),
            textAlign: TextAlign.center,
          )
        ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed!,
      onLongPress: () => onLongPress != null ?
      onLongPress!() : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.theme.accentColor,
        textStyle: const TextStyle(
          fontFamily: appFont,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: provider.theme.isDarkForAccent! ?
              Colors.black : Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      )
    );
  }
}
