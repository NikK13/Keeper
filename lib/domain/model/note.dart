import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/fields.dart';

import '../../presenter/widgets/general/ripple.dart';
import '../utils/styles.dart';

class Note{
  int? id;
  String? title;
  String? body;
  num? created;
  num? updated;

  Note({
    this.id,
    this.body,
    this.title,
    this.created,
    this.updated
  });

  factory Note.fromJson(int elementId, Map<String, dynamic> json) => Note(
    id: elementId,
    title: json[fieldTitle],
    body: json[fieldBody],
    created: json[fieldCreated],
    updated: json[fieldUpdated],
  );

  Map<String, dynamic> toJson() => {
    fieldTitle: title ?? "",
    fieldBody: body ?? "",
    fieldCreated: created ?? 0,
    fieldUpdated: updated ?? 0,
  };
}

class NoteItem extends StatelessWidget {
  final Note? note;

  const NoteItem({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: note!,
      child: Ripple(
        onTap: (){
          /*Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => note!.category! == "default" ?
              SimpleNoteScreen(note: note) : TasksNoteScreen(note: note),
              transitionDuration: const Duration(milliseconds: 250),
            ),
          );*/
        },
        onLongPress: (){
          /*showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)
                  )
              ),
              context: context,
              constraints: getDialogConstraints(context),
              isScrollControlled: false,
              isDismissible: true,
              builder: (context) => NotesMenuDialog(
                note: note,
              )
          );*/
        },
        radius: 16,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light ?
              Colors.black : Colors.white,
              width: 0.05
            ),
            color: secondaryColor(context),
            borderRadius: BorderRadius.circular(16)
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16, right: 16,
              top: 16, bottom: 8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note!.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                    /*Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColorByPriority(note!.priority!)
                    ),
                  )*/
                  ],
                ),
                const SizedBox(height: 8),
                //if(note!.category! == "default")
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
                /*if(note!.category! == "tasks")
                Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: note!.items!.asMap().map((index, value){
                      final item = note!.items![index];
                      return MapEntry(index, getTaskView(item));
                    }).values.toList(),
                  )
                ),*/
              ],
            )
          ),
        ),
      ),
    );
  }

 /* Widget getTaskView(Item item){
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 2
      ),
      child: Row(
        children: [
          SelectedCheckBox(
            isSelected: item.isDone,
            onTap: (){},
            size: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              item.title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }*/
}