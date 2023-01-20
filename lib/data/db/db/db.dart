// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:keeper/data/db/db/entities/note.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseProvider{
  static late Future<Isar> _db;

  static const String dbName = "keeper";
  static const String dbExt = "isar";

  static const String dbFilePath = "$dbName.$dbExt";

  static Future<void> initDatabase() async{
    _db = _openIsar();
  }

  static Future<Isar> get isarDb async => _db;

  static Future<Isar> _openIsar() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        _schemas,
        directory: !kIsWeb ?
        documentsDirectory.path : null,
        name: dbName, inspector: false,
      );
    }
    return Future.value(Isar.getInstance());
  }

  /*static Future reCreateDatabase([File? newFile]) async{
    final tempPath = newFile!.path.replaceAll("/$dbFilePath", "").trim();
    debugPrint(tempPath);
    Isar isar = await _db;
    await isar.writeTxn(() async => await isar.clear());
    await isar.close();
    isar = await Isar.open(_schemas, directory: tempPath, name: dbName);
    if(isar.isOpen){
      final cars = await isar.carEntitys.where().build().findAll();
      final services = await isar.serviceEntitys.where().build().findAll();
      final trips = await isar.tripEntitys.where().build().findAll();
      final places = await isar.placeEntitys.where().build().findAll();
      await isar.close();
      await initDatabase();
      final newDb = await _db;
      await _reCreateCars(newDb, cars);
      await _reCreateServices(newDb, services);
      await _reCreateTrips(newDb, trips);
      await _reCreatePlaces(newDb, places);
      debugPrint("---SUCCESS---");
    }
  }*/

  /*static Future<void> _reCreateCars(Isar isar, List<CarEntity> list) async{
    if(list.isNotEmpty){
      await isar.writeTxn(() async => await isar.carEntitys.putAll(list));
    }
  }

  static Future<void> _reCreateServices(Isar isar, List<ServiceEntity> list) async{
    if(list.isNotEmpty){
      await isar.writeTxn(() async => await isar.serviceEntitys.putAll(list));
    }
  }

  static Future<void> _reCreateTrips(Isar isar, List<TripEntity> list) async{
    if(list.isNotEmpty){
      await isar.writeTxn(() async => await isar.tripEntitys.putAll(list));
    }
  }

  static Future<void> _reCreatePlaces(Isar isar, List<PlaceEntity> list) async{
    if(list.isNotEmpty){
      await isar.writeTxn(() async => await isar.placeEntitys.putAll(list));
    }
  }*/

  static List<CollectionSchema<dynamic>> get _schemas => [
    NoteEntitySchema
  ];
}