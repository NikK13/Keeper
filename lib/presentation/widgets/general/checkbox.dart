import 'package:flutter/material.dart';
import 'package:keeper/presenter/widgets/general/ripple.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';

class AppCheckBox extends StatelessWidget {
  final bool? isSelected;
  final Function()? onTap;
  final double size;

  const AppCheckBox({
    Key? key,
    this.isSelected,
    this.onTap,
    this.size = 32
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Ripple(
      radius: 14,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected! ?
          provider.theme.accentColor :
          Theme.of(context).brightness == Brightness.light ?
          Colors.grey.shade300 : Colors.grey.shade800
        ),
        child: isSelected! ? Icon(
          Icons.check,
          color: Colors.white,
          size: size / 1.35,
        ) : const SizedBox(),
      ),
    );
  }
}