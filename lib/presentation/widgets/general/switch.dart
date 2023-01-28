import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../provider/provider.dart';

class CustomSwitch extends StatefulWidget {
  final bool? value;
  final Color? enableColor;
  final Color disableColor;
  final double? switchHeight;
  final double? switchWidth;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    Key? key,
    this.value,
    this.enableColor,
    this.disableColor = Colors.grey,
    this.switchHeight,
    this.switchWidth,
    this.onChanged
  }) : super(key: key);

  @override
  State createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Transform.scale(
        scale: isIosApplication ? 1.2 : 1.15,
        child: InkWell(
          splashColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            width: isIosApplication ? 42 : 50,
            height: isIosApplication ? 30 : 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: widget.value! ? provider.theme.accentColor :
              Colors.grey.shade400,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: widget.value! ? Alignment.centerRight :
              Alignment.centerLeft, curve: Curves.decelerate,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isIosApplication ? 0 : 1,
                  vertical: 2
                ),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() => widget.onChanged!(widget.value!));
          },
        ),
      ),
    );
  }
}