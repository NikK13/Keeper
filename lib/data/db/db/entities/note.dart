import 'package:isar/isar.dart';
part 'note.g.dart';

@collection
class NoteEntity{
  Id id = Isar.autoIncrement;
  String? data;
}