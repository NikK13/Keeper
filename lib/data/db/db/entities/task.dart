import 'package:isar/isar.dart';
part 'task.g.dart';

@collection
class TaskEntity{
  Id id = Isar.autoIncrement;
  String? data;
}