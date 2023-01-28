import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:keeper/domain/utils/styles.dart';
import 'package:keeper/presenter/bloc/db_bloc.dart';
import 'package:keeper/presenter/provider/provider.dart';
import 'package:keeper/presenter/widgets/general/app_page.dart';
import 'package:keeper/presenter/widgets/general/checkbox.dart';
import 'package:keeper/presenter/widgets/general/dialogs.dart';
import 'package:provider/provider.dart';

import '../../domain/utils/constants.dart';
import '../../domain/utils/extensions.dart';
import '../../domain/utils/localization.dart';
import '../dialog/new_item_dialog.dart';
import '../widgets/general/chips.dart';

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

  Note? _note;

  int _selectedIndex = 0;

  void Function(void Function())? _setIndexState, _setItemsState;

  final List<Item> _items = [];

  @override
  void initState() {
    _type = widget.extras?['type'] ?? notesType;
    _note = widget.extras?['note'];
    _bloc = widget.extras?['db_bloc'];
    _titleController.text = (_note != null ? _note!.title! : "");
    if(_note != null){
      _selectedIndex = getIndexByPriority(_note!.priority!);
      switch(_type){
        case notesType:
          _descController.text = (_note != null ? _note!.body! : "");
          break;
        case tasksType:
          _items.addAll(_note!.items!);
          break;
      }
    }
    super.initState();
  }

  void changeActiveState(Item item){
    _setItemsState!(() => item.isDone = !item.isDone!);
  }

  void deleteItemFromList(int index){
    _setItemsState!(() => _items.removeAt(index));
  }

  void createNewItemInList(String title, [String? desc]){
    _setItemsState!((){
      _items.add(Item(
        title: title,
        desc: desc ?? "",
        isDone: false
      ));
    });
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
                    size: isIosApplication ? 26 : 32,
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
                    if(_type == notesType){
                      if(_note != null){
                        await _updateNote(context);
                      }
                      else{
                        await _createNote(context);
                      }
                    }
                    else if(_type == tasksType){
                      if(_note != null){
                        await _updateTasks(context);
                      }
                      else{
                        await _createTasks(context);
                      }
                    }
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            AppLocalizations.of(context, 'priority'),
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
                    ),
                    if(_note != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          DateFormat(
                            'dd MMMM, yyyy, ${provider.is24HourFormat! ?
                            "HH:mm" : "hh:mm a"}',
                            Localizations.localeOf(context).toLanguageTag()
                          ).format(DateTime.fromMillisecondsSinceEpoch(_note!.updated!.toInt())),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      cursorColor: provider.theme.accentColor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context, 'hint_title'),
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 24
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if(_type == notesType)
                    TextField(
                      controller: _descController,
                      cursorColor: provider.theme.accentColor,
                      minLines: 1,
                      maxLines: 10,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17
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
                    if(_type == tasksType)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context, 'tasks'),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showContentDialog(context, NewItemDialog(
                                  addNewItem: createNewItemInList,
                                ));
                              },
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: accent(context),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        StatefulBuilder(
                          builder: (_, setItem){
                            _setItemsState = setItem;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _items.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return TaskItem(
                                  task: _items[index],
                                  changeActive: () => changeActiveState(_items[index]),
                                  removeItem: () => deleteItemFromList(index),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _updateNote(BuildContext context) async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      context.pop();
      await _bloc.updateNote(Note(
        id: _note!.id,
        title: title,
        body: desc,
        created: _note!.created,
        category: _note!.category,
        updated: DateTime.now().millisecondsSinceEpoch,
        priority: getPriorityByIndex(_selectedIndex),
      ));
    }
  }

  Future _createNote(BuildContext context) async{
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if(title.isNotEmpty && desc.isNotEmpty){
      context.pop();
      await _bloc.addNote(Note(
        title: title,
        body: desc,
        category: _type,
        created: DateTime.now().millisecondsSinceEpoch,
        updated: DateTime.now().millisecondsSinceEpoch,
        priority: getPriorityByIndex(_selectedIndex),
      ));
    }
  }

  Future _createTasks(BuildContext context) async{
    final title = _titleController.text.trim();
    if(title.isNotEmpty){
      context.pop();
      await _bloc.addTasks(Note(
        title: title,
        category: _type,
        created: DateTime.now().millisecondsSinceEpoch,
        updated: DateTime.now().millisecondsSinceEpoch,
        priority: getPriorityByIndex(_selectedIndex),
        items: _items
      ));
    }
  }

  Future _updateTasks(BuildContext context) async{
    final title = _titleController.text.trim();
    if(title.isNotEmpty){
      context.pop();
      await _bloc.updateTasks(Note(
        id: _note!.id,
        title: title,
        category: _note!.category,
        created: _note!.created,
        updated: DateTime.now().millisecondsSinceEpoch,
        priority: getPriorityByIndex(_selectedIndex),
        items: _items
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

class TaskItem extends StatelessWidget {
  final Item? task;
  final Function? changeActive;
  final Function? removeItem;

  const TaskItem({
    Key? key,
    this.task,
    this.changeActive,
    this.removeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey,
            width: 0.08
          ),
          color: secondaryColor(context)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              AppCheckBox(
                isSelected: task!.isDone,
                onTap: () => changeActive!(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task!.title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if(task!.desc!.trim().isNotEmpty)
                    Text(
                      task!.desc!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 28,
                  color: Colors.grey,
                ),
                onPressed: () => removeItem!()
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
