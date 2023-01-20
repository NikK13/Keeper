import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keeper/domain/utils/styles.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Function? onTap;
  final Function? onMapTap;
  final Function? onChanged;
  final bool? isDatePick;
  final bool isMapOpenable;
  final bool showClearBtn;
  final double borderRadius;
  final TextInputType inputType;
  final TextInputType numberInputType;

  const InputField({Key? key,
    this.title,
    this.controller,
    this.hint,
    this.isDatePick,
    this.onTap,
    this.prefixIcon,
    this.onMapTap,
    this.onChanged,
    this.suffixIcon,
    this.showClearBtn = false,
    this.isMapOpenable = false,
    this.numberInputType = numberTypeForInputs,
    this.inputType = numberTypeForInputs,
    this.borderRadius = 8
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if(title != null)
        Column(
          children: [
            Text(" $title",
              maxLines: 1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
            ),
            const SizedBox(height: 4),
          ],
        ),
        GestureDetector(
          onTap: (isDatePick! ? () => onTap!() : null),
          child: TextField(
            enabled: !isDatePick!,
            controller: controller,
            keyboardType: inputType,
            cursorColor: provider.theme.accentColor,
            textInputAction: TextInputAction.done,
            inputFormatters: <TextInputFormatter>[
              inputType == numberInputType
              ? FilteringTextInputFormatter.allow(RegExp("[0-9.,]"))
              : FilteringTextInputFormatter.deny('')
            ],
            onChanged: onChanged != null ?
            (String value) => onChanged!(value) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: secondaryColor(context),
              hintStyle: const TextStyle(fontSize: 16),
              suffixIcon: isMapOpenable ? GestureDetector(
                onTap: () => onMapTap!(),
                child: Icon(
                  Icons.map_rounded,
                  color: Colors.grey.withOpacity(0.75),
                  size: 24,
                )
              ) : suffixIcon,
              prefixIcon: prefixIcon,
              border: inputBorder(context),
              enabledBorder: inputBorder(context),
              disabledBorder: inputBorder(context),
              focusedBorder: inputBorder(context),
              hintText: hint,
              contentPadding: const EdgeInsets.all(10)
            ),
          ),
        )
      ]
    );
  }

  InputBorder inputBorder(context) => OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    borderSide: BorderSide(
      color: backgroundColor(context),
      width: 0
    )
  );
}
