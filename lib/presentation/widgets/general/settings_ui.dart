import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../../domain/utils/styles.dart';
import '../../provider/provider.dart';
import 'ripple.dart';

class SettingsRow extends StatelessWidget {
  final String? title;
  final String? trailing;
  final Function? onTap;
  final Function? onLongTap;
  final IconData? icon;
  final Widget? switchData;
  final bool? isFirst;
  final bool? isLast;

  const SettingsRow({
    Key? key,
    required this.title,
    required this.onTap,
    this.trailing,
    required this.icon,
    this.switchData,
    this.onLongTap,
    required this.isLast,
    required this.isFirst
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return !isIosApplication ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Ripple(
        radius: 16,
        rippleColor: Colors.transparent,
        onTap: () => onTap!(),
        onLongPress: onLongTap != null ?
        () => onLongTap!() : () {},
        child: SizedBox(
          width: double.infinity,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.only(
                left: 4, right: 8,
                top: trailing != null ? 12 : 15,
                bottom: trailing != null ? 12 : 15
              ),
              child:Row(
                children: [
                  Icon(
                    icon!,
                    size: 32,
                    color: Theme.of(context).brightness == Brightness.dark ?
                    Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),
                        if(trailing != null)
                        Text(
                          trailing!,
                          style: TextStyle(
                            fontSize: 14,
                            color: provider.theme.accentColor,
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  if(switchData != null)
                  switchData!
                ],
              ),
            ),
          ),
        ),
      ),
    ) : GestureDetector(
      onTap: () => onTap!(),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey.withOpacity(0.5)
            ),
            borderRadius: BorderRadius.only(
              topLeft: isFirst! ? const Radius.circular(16) : Radius.zero,
              topRight: isFirst! ? const Radius.circular(16) : Radius.zero,
              bottomLeft: isLast! ? const Radius.circular(16) : Radius.zero,
              bottomRight: isLast! ? const Radius.circular(16) : Radius.zero,
            )
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if(icon != null)
                  Icon(
                    icon,
                    size: 22,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if(trailing != null)
                  Row(
                    children: [
                      Text(
                        trailing!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      )
                    ],
                  ),
                  if(switchData != null)
                  switchData!
                ],
              )
          ),
        ),
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String? title;

  const SettingsTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        title!,
        style: TextStyle(
          fontFamily: appFont,
          fontWeight: isIosApplication ?
          FontWeight.w600 : FontWeight.w700,
          color: isIosApplication ?
          Colors.grey : provider.theme.accentColor,
          fontSize: !isIosApplication ? 12 : 14,
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsRow>? settingsItems;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.settingsItems
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTitle(title: title),
        Padding(
          padding: EdgeInsets.only(
            bottom: defaultTargetPlatform == TargetPlatform.iOS ? 0 : 32
          ),
          child: ListView.builder(
            itemCount: settingsItems!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return settingsItems![index];
            },
          ),
        ),
      ],
    );
  }
}


