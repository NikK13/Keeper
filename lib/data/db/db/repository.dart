import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:keeper/data/db/db/entities/note.dart';
import 'package:keeper/data/db/db/entities/task.dart';
import 'package:keeper/domain/model/note.dart';

import 'db.dart';

class DbRepository{
  Future<void> createNote(Note item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = NoteEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.noteEntitys.put(dbItem));
  }

  Future<void> createTasks(Note item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = TaskEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.taskEntitys.put(dbItem));
  }

  Future<List<Note>> getNotes([String? query]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.noteEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length, (index) => Note.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!)));
    return query != null && query.isNotEmpty ? list.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList() : list;
  }

  Future<List<Note>> getTasks([String? query]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.taskEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length, (index) => Note.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!)));
    return query != null && query.isNotEmpty ? list.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList() : list;
  }

  Future<void> deleteNote(int id) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() => isar.noteEntitys.delete(id));
  }

  Future<void> deleteTasks(int id) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() => isar.taskEntitys.delete(id));
  }

  Future<void> updateNote(Note item) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() async{
      final dbEntity = await isar.noteEntitys.get(item.id!);
      if(dbEntity != null){
        dbEntity.data = jsonEncode(item);
        await isar.noteEntitys.put(dbEntity);
      }
    });
  }

  Future<void> updateTasks(Note item) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() async{
      final dbEntity = await isar.taskEntitys.get(item.id!);
      if(dbEntity != null){
        dbEntity.data = jsonEncode(item);
        await isar.taskEntitys.put(dbEntity);
      }
    });
  }
}