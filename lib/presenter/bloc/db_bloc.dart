import 'package:keeper/data/db/db/repository.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class DatabaseBloc extends BaseBloc{
  final repository = DbRepository();

  final _allNotes = BehaviorSubject<List<Note>?>();
  final _allTasks = BehaviorSubject<List<Note>?>();

  Stream<List<Note>?> get allNotesStream => _allNotes.stream;
  Stream<List<Note>?> get allTasksStream => _allTasks.stream;

  Function(List<Note>?) get loadAllNotes => _allNotes.sink.add;
  Function(List<Note>?) get loadAllTasks => _allTasks.sink.add;

  String searchQuery = "";

  Future getNotes() async{
    await loadAllNotes(null);
    final List<Note> items = await repository.getNotes(searchQuery);
    await loadAllNotes(items);
  }

  Future addNote(Note item) async{
    await repository.createNote(item);
    await getNotes();
  }

  Future updateNote(Note item) async{
    await repository.updateNote(item);
    await getNotes();
  }

  Future deleteNote(int id, [bool isWithReload = true]) async {
    await repository.deleteNote(id);
    if(isWithReload){
      await getNotes();
    }
  }

  Future getTasks() async{
    await loadAllTasks(null);
    final List<Note> items = await repository.getTasks(searchQuery);
    await loadAllTasks(items);
  }

  Future addTasks(Note item) async{
    await repository.createTasks(item);
    await getTasks();
  }

  Future updateTasks(Note item) async{
    await repository.updateTasks(item);
    await getTasks();
  }

  Future deleteTasks(int id, [bool isWithReload = true]) async {
    await repository.deleteTasks(id);
    if(isWithReload){
      await getNotes();
    }
  }

  @override
  void dispose() {
    _allNotes.close();
    _allTasks.close();
  }
}