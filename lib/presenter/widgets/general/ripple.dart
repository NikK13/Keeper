import 'package:flutter/material.dart';

class Ripple extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final double? radius;
  final double elevation;
  final Color? rippleColor;
  final Border? border;
  final bool withRipple;

  const Ripple({
    Key? key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.elevation = 0,
    this.radius,
    this.rippleColor,
    this.border,
    this.withRipple = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(radius!)),
      color: rippleColor ?? Colors.transparent,
      elevation: elevation,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          border: border
        ),
        child: InkWell(
          //splashFactory: NoSplash.splashFactory,
          highlightColor: !withRipple ? Colors.transparent : null,
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          onTap: onTap,
          onLongPress: onLongPress,
          child: child,
        ),
      ),
    );
  }
}
