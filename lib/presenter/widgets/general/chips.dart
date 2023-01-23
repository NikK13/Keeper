import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:keeper/domain/utils/styles.dart';

import '../../../domain/utils/localization.dart';

class ChipsList extends StatelessWidget {
  final int? index;
  final Color? color;
  final Function? func;

  const ChipsList({
    Key? key,
    this.index, this.color, this.func
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];
    List options = [
      AppLocalizations.of(context, 'low'),
      AppLocalizations.of(context, 'medium'),
      AppLocalizations.of(context, 'high')
    ];
    for (int i = 0; i < options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: index == i,
        label: Text(
          options[i],
          style: TextStyle(
            color: accent(context),
            fontWeight: FontWeight.w500,
            fontSize: 14
          ),
        ),
        elevation: 2,
        pressElevation: 4,
        backgroundColor: secondaryColor(context),
        selectedColor: color,
        onSelected: (bool selected) => func!(selected, i),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
        ),
      );
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: choiceChip,
        ),
      );
    }
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        fontFamily: appFont,
        chipTheme: const ChipThemeData(
          checkmarkColor: Colors.white,
        )
      ),
      child: SizedBox(
        height: 50,
        child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: chips,
        ),
      ),
    );
  }
}