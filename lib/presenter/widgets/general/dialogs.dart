import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../../domain/utils/constants.dart';
import '../../../domain/utils/extensions.dart';
import '../../../domain/utils/localization.dart';
import '../../../domain/utils/styles.dart';

showContentDialog(context, child, [isOnMain = false, double size = 0.95]){
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    constraints: getDialogConstraints(context, size),
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (context) => child
  );
}

void showActionsDialog(context, title, content, posTitle, posAction){
  final provider = Provider.of<PreferenceProvider>(context, listen: false);
  if(isIosApplication){
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: appFont
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: appFont
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context, 'cancel'),
              style: TextStyle(
                color: provider.theme.accentColor,
                fontWeight: FontWeight.w500,
                fontFamily: appFont
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () async{
              Navigator.pop(context);
              await posAction!();
            },
            child: Text(
              posTitle,
              style: TextStyle(
                color: provider.theme.accentColor,
                fontWeight: FontWeight.w500,
                fontFamily: appFont
              ),
            ),
          ),
        ],
      )
    );
  }
  else{
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: appFont
          ),
        ),
        content:  Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context, 'cancel'),
              style: TextStyle(
                color: provider.theme.accentColor
              ),
            ),
            onPressed: () => Navigator.pop(context)
          ),
          TextButton(
            child: Text(
              posTitle,
              style: TextStyle(
                color: provider.theme.accentColor
              ),
            ),
            onPressed: () async{
              Navigator.pop(context);
              await posAction!();
            },
          ),
        ],
      )
    );
  }
}
