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
      radius: 30,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected! ?
          provider.theme.accentColor :
          Colors.grey.shade300
        ),
        child: isSelected! ? Icon(
          Icons.check,
          color: Colors.white,
          size: size / 1.45,
        ) : const SizedBox(),
      ),
    );
  }
}