import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:keeper/presenter/widgets/general/app_page.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/constants.dart';
import '../../domain/utils/extensions.dart';
import '../../domain/utils/localization.dart';

class NoteViewPage extends StatefulWidget {
  final Map<String, dynamic>? extras;

  const NoteViewPage({super.key, this.extras});

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late String _type;
  late DatabaseBloc _bloc;

  String? _locale;
  Note? _note;

  @override
  void initState() {
    _type = widget.extras?['type'] ?? "";
    _note = widget.extras?['note'];
    _bloc = widget.extras?['db_bloc'];
    debugPrint("$_type, NOTE: $_note");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _locale ??= Localizations.localeOf(context).languageCode.contains("ru") ?
      "kk:mm" : "hh:mm a";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppPage(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    context.pop();
                  },
                  child: Icon(
                    isIosApplication ?
                    Icons.arrow_back_ios :
                    Icons.arrow_back,
                    size: isIosApplication ? 27 : 32,
                    color: accent(context),
                  ),
                ),
                Text(
                  AppLocalizations.of(context, 'notes'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async{
                    await _createNote(context);
                  },
                  child: Icon(
                    Icons.check,
                    size: 33,
                    color: accent(context),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            "PRIORITY",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatefulBuilder(
                          builder: (_, setItem){
                            _setIndexState = setItem;
                            return SingleChildScrollView(
                              child: ChipsList(
                                index: _selectedIndex,
                                color: getColorByPriority(getPriorityByIndex(_selectedIndex)),
                                func: (selected, index) {
                                  _setIndexState!((){
                                    if (selected) {
                                      _selectedIndex = index;
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),*/
                    if(_note != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'dd MMMM, yyyy, $_locale',
                            Localizations.localeOf(context).toLanguageTag()
                          ).format(DateTime.fromMillisecondsSinceEpoch(_note!.created!.toInt())),
                          style: const TextStyle(
                            fontSize: 13
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    TextField(
                      controller: _titleController,
                      cursorColor: provider.theme.accentColor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context, 'hint_title'),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 22
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: _descController,
                      cursorColor: provider.theme.accentColor,
                      minLines: 1,
                      maxLines: 10,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context, 'hint_desc'),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 16
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Future _updateNote() async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      await _bloc.addNote(Note(

      ));
      *//*await notesBloc.updateItem(
          Note(
            id: note.id,
            title: title,
            desc: desc,
            date: DateTime.now().millisecondsSinceEpoch,
            category: note.category,
            priority: getPriorityByIndex(_selectedIndex),
            image: note.image,
            items: note.items,
          )
      );*//*
    }
  }*/

  Future _createNote(BuildContext context) async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      context.pop();
      await _bloc.addNote(Note(
        title: title,
        body: desc,
        created: DateTime.now().millisecondsSinceEpoch,
        updated: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
