import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:keeper/data/db/db/entities/note.dart';
import 'package:keeper/domain/model/note.dart';

import 'db.dart';

class DbRepository{
  Future<void> createNote(Note item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = NoteEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.noteEntitys.put(dbItem));
  }

  /*Future<void> createService(CarService item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = ServiceEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.serviceEntitys.put(dbItem));
  }

  Future<void> createPlace(Place item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = PlaceEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.placeEntitys.put(dbItem));
  }

  Future<int> createReminder(Reminder item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = ReminderEntity()..data = jsonEncode(item);
    return await isar.writeTxn(() => isar.reminderEntitys.put(dbItem));
  }

  Future<void> createTrip(Trip item) async {
    final isar = await DatabaseProvider.isarDb;
    final dbItem = TripEntity()..data = jsonEncode(item);
    await isar.writeTxn(() => isar.tripEntitys.put(dbItem));
  }*/

  /*Future<Car?> getCarById(int id) async {
    final isar = await DatabaseProvider.isarDb;
    final carEntity = await isar.carEntitys.get(id);
    final car = carEntity != null ?
    Car.fromJson(carEntity.id, jsonDecode(carEntity.data!)) : null;
    return car;
  }*/

  Future<List<Note>> getNotes([String? query]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.noteEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length, (index) => Note.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!)));
    return query != null && query.isNotEmpty
    ? list.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList() : list;
  }

  /*Future<List<CarService>> getAllServices([int? range]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.serviceEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length, (index) => CarService.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!))).reversed.toList();
    return list.getRange(0, range != null ? (range > list.length ? list.length : range) : list.length).toList();
  }

  Future<List<Reminder>> getAllReminders() async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.reminderEntitys.where().build().findAll();
    return List.generate(itemsDb.length, (index) => Reminder.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!))).reversed.toList();
  }

  Future<List<Place>> getAllPlaces([String? type]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.placeEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length, (index) => Place.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!))).reversed.toList();
    if(type != null){
      return list.where((element) => element.placeType == type).toList();
    }
    return list;
  }

  Future<List<Trip>> getAllTrips() async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.tripEntitys.where().build().findAll();
    return List.generate(itemsDb.length, (index) => Trip.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!))).reversed.toList();
  }

  Future<List<num>> getCarExpensesByType(String type, id) async{
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.serviceEntitys.where().build().findAll();
    List<CarService> carsDataList = List.generate(
      itemsDb.length, (index) => CarService.fromJson(
        itemsDb[index].id, jsonDecode(itemsDb[index].data!)
      )
    ).where((element) => element.carId == id && element.type == type).toList();
    final count = int.tryParse(carsDataList.length.toString()) ?? 0;
    double summary = 0.0;
    for(var item in carsDataList){
      summary += item.price ?? 0.0;
    }
    return [summary, count];
  }

  Future<List<CarService>> getServicesPerCar(int carId, [int? range]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.serviceEntitys.where().build().findAll();
    final list = List.generate(itemsDb.length,
    (index) => CarService.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!))).
    reversed.toList().where((element) => element.carId == carId).toList();
    return list.getRange(0, range != null ? (range > list.length ? list.length : range) : list.length).toList();
  }

  Future<List<CarService>> getFilteredServices([int? carId, String sortType = newestSort]) async {
    final isar = await DatabaseProvider.isarDb;
    final itemsDb = await isar.serviceEntitys.where().build().findAll();
    List<CarService> list = List.generate(itemsDb.length, (index) => CarService.fromJson(itemsDb[index].id, jsonDecode(itemsDb[index].data!)));
    switch(sortType){
      case newestSort:
        if(carId != null){
          list = [...list].where((element) => element.carId == carId).toList();
        }
        list.sort((a,b) => b.id!.compareTo(a.id!));
        break;
      case oldestSort:
        if(carId != null){
          list = [...list].where((element) => element.carId == carId).toList();
        }
        list.sort((a,b) => a.id!.compareTo(b.id!));
        break;
      case cheapestSort:
        if(carId != null){
          list = [...list].where((element) => element.carId == carId).toList();
        }
        list.sort((a,b) => a.price!.compareTo(b.price!));
        break;
      case expensiveSort:
        if(carId != null){
          list = [...list].where((element) => element.carId == carId).toList();
        }
        list.sort((a,b) => b.price!.compareTo(a.price!));
        break;
    }
    return list;
  }*/

  /*Future<bool> deleteReminder(int id) async {
    final isar = await DatabaseProvider.isarDb;
    return await isar.writeTxn(() => isar.reminderEntitys.delete(id));
  }

  Future<bool> deleteTrip(int id) async {
    final isar = await DatabaseProvider.isarDb;
    return await isar.writeTxn(() => isar.tripEntitys.delete(id));
  }

  Future<bool> deletePlace(int id) async {
    final isar = await DatabaseProvider.isarDb;
    return await isar.writeTxn(() => isar.placeEntitys.delete(id));
  }

  Future<bool> deleteService(int id) async {
    final isar = await DatabaseProvider.isarDb;
    return await isar.writeTxn(() => isar.serviceEntitys.delete(id));
  }*/

  Future<void> deleteNote(int id) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() => isar.noteEntitys.delete(id));
  }

  /*Future<void> deleteServicesWithCar(int id) async {
    final isar = await DatabaseProvider.isarDb;
    final services = await getServicesPerCar(id);
    final List<int> idList = [];
    for (var item in services) {
      if(item.carId == id){
        idList.add(item.id!);
      }
    }
    debugPrint("SERVICES LIST(Size: ${services.length}): ${idList.toString()}");
    return await isar.writeTxn(() => isar.serviceEntitys.deleteAll(idList));
  }

  Future<int> deleteTripsWithCar(int id) async {
    final isar = await DatabaseProvider.isarDb;
    final trips = await getAllTrips();
    final List<int> idList = [];
    for (var item in trips) {
      if(item.carId == id){
        idList.add(item.id!);
      }
    }
    return await isar.writeTxn(() => isar.tripEntitys.deleteAll(idList));
  }

  Future<int> deleteRemindersWithCar(int id) async {
    final isar = await DatabaseProvider.isarDb;
    final reminders = (await getAllReminders());
    final List<int> idList = [];
    for (var item in reminders) {
      if(!item.isScheduled! && item.carId == id){
        idList.add(item.id!);
      }
    }
    return await isar.writeTxn(() => isar.reminderEntitys.deleteAll(idList));
  }*/

  /*Future<void> updateCar(Car car) async {
    final isar = await DatabaseProvider.isarDb;
    await isar.writeTxn(() async{
      final dbEntity = await isar.carEntitys.get(car.id!);
      if(dbEntity != null){
        dbEntity.data = jsonEncode(car);
        await isar.carEntitys.put(dbEntity);
      }
    });
  }*/
}