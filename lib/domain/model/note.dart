// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keeper/data/navigator/navigator.dart';
import 'package:keeper/domain/utils/constants.dart';
import 'package:keeper/domain/utils/extensions.dart';
import 'package:keeper/domain/utils/fields.dart';
import 'package:keeper/domain/utils/localization.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/widgets/general/checkbox.dart';
import 'package:keeper/presenter/widgets/general/ripple.dart';

import '../../data/navigator/routes.dart';
import '../utils/styles.dart';

class Item{
  String? title;
  String? desc;
  bool? isDone;

  Item({this.title, this.isDone, this.desc});

  static Map<String, dynamic> toMap(Item item) => {
    fieldTitle: item.title,
    fieldIsDone: item.isDone,
    fieldBody: item.desc
  };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    title: json[fieldTitle],
    isDone: json[fieldIsDone],
    desc: json[fieldBody]
  );
}

class Note{
  final int? id;
  final String? title;
  final String? body;
  final String? priority;
  final String? category;
  final List<Item>? items;
  final num? created;
  final num? updated;

  Note({
    this.id,
    this.body,
    this.title,
    this.created,
    this.updated,
    this.priority,
    this.category,
    this.items
  });

  factory Note.fromJson(int elementId, Map<String, dynamic> parsedJson) => Note(
    id: elementId,
    title: parsedJson[fieldTitle],
    body: parsedJson[fieldBody],
    created: parsedJson[fieldCreated],
    updated: parsedJson[fieldUpdated],
    priority: parsedJson[fieldPriority],
    category: parsedJson[fieldCategory],
    items: parsedJson[fieldItems] != null ?
    (json.decode(parsedJson[fieldItems]) as List<dynamic>)
    .map<Item>((item) => Item.fromJson(item)).toList() : null
  );

  Map<String, dynamic> toJson() => {
    fieldTitle: title ?? "",
    fieldBody: body ?? "",
    fieldCreated: created ?? 0,
    fieldUpdated: updated ?? 0,
    fieldPriority: priority ?? "",
    fieldCategory: category ?? "",
    fieldItems: items != null ? json.encode(items!.map<Map<String, dynamic>>
    ((item) => Item.toMap(item)).toList()) : null
  };
}

class NoteItem extends StatelessWidget {
  final Note? note;
  final DatabaseBloc? dbBloc;

  const NoteItem({Key? key, this.note, this.dbBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isIosApplication ? CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: (){

          },
          trailingIcon: CupertinoIcons.share,
          child: Text(
            AppLocalizations.of(context, 'share'),
            style: const TextStyle(
              fontFamily: appFont,
              fontSize: 18
            ),
          ),
        ),
        CupertinoContextMenuAction(
          onPressed: () async{
            Navigator.of(context, rootNavigator: true).pop();
            await Future.delayed(const Duration(milliseconds: 425));
            switch(note!.category){
              case notesType:
                await dbBloc!.deleteNote(note!.id!);
                break;
              case tasksType:
                await dbBloc!.deleteTasks(note!.id!);
                break;
            }
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: Text(
            AppLocalizations.of(context, 'delete'),
            style: const TextStyle(
              fontFamily: appFont,
              fontSize: 18
            ),
          ),
        ),
      ],
      child: noteView(context)
    ) : noteView(context);
  }

  Widget noteView(BuildContext context) => Ripple(
    radius: 16,
    onTap: () {
      AppNavigator.instance.globalContext.push(
        AppRoutes.noteViewPath, {
          "note": note,
          "type": note!.category,
          "db_bloc": dbBloc
        }
      );
    },
    onLongPress: (){
      if(!isIosApplication){
        debugPrint("LONG PRESS");
      }
    },
    rippleColor: secondaryColor(context),
    border: Border.all(
      color: Colors.grey,
      width: 0.08
    ),
    withRipple: !isIosApplication,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 16, right: 16,
        top: 16, bottom: 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note!.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          if(note!.category! == notesType)
          Expanded(
            child: Text(
              note!.body!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if(note!.category! == tasksType)
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: note!.items!.asMap().map((index, value){
                final item = note!.items![index];
                return MapEntry(index, getTaskView(item));
              }).values.toList(),
            )
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "${AppLocalizations.of(context, "priority")}:",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: getColorByPriority(note!.priority!)
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    AppLocalizations.of(context, note!.priority!),
                    style: const TextStyle(
                      fontSize: 8.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      )
    ),
  );

  Widget getTaskView(Item item){
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2
      ),
      child: Row(
        children: [
          AppCheckBox(
            isSelected: item.isDone,
            onTap: (){},
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              item.title!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                decoration: item.isDone! ?
                TextDecoration.lineThrough :
                TextDecoration.none,
                decorationStyle: TextDecorationStyle.solid
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}