import 'package:isar/isar.dart';
part 'reminder.g.dart';

@collection
class ReminderEntity{
  Id id = Isar.autoIncrement;
  String? data;
}