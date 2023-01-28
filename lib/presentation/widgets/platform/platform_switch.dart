import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/constants.dart';

class PlatformSwitch extends StatelessWidget {
  final bool value;
  final Color? enabledColor;
  final Color disableColor;
  final ValueChanged<bool>? onChanged;

  const PlatformSwitch({
    Key? key,
    this.enabledColor,
    this.disableColor = Colors.grey,
    this.onChanged,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isIosApplication ? CupertinoSwitch(
      activeColor: enabledColor,
      onChanged: onChanged,
      value: value,
    ) : Switch(
      activeColor: enabledColor,
      onChanged: onChanged,
      value: value,
    );
  }
}
