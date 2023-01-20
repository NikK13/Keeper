import 'package:keeper/data/db/db/repository.dart';
import 'package:keeper/domain/model/note.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class DatabaseBloc extends BaseBloc{
  final repository = DbRepository();

  final _allNotes = BehaviorSubject<List<Note>?>();

  Stream<List<Note>?> get allNotesStream => _allNotes.stream;

  Function(List<Note>?) get loadAllNotes => _allNotes.sink.add;

  Future getNotes([String? query]) async{
    await loadAllNotes(null);
    final List<Note> items = await repository.getNotes(query);
    await loadAllNotes(items);
  }

  Future addNote(Note item) async{
    await repository.createNote(item);
    await getNotes();
  }

  Future deleteNote(int id, [bool isWithReload = true]) async {
    await repository.deleteNote(id);
    if(isWithReload){
      await getNotes();
    }
  }

  @override
  void dispose() {
    _allNotes.close();
  }
}