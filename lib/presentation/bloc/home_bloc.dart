import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../data/navigator/routes.dart';
import 'bloc.dart';

class HomePageBloc extends BaseBloc{
  late String currentLocation;

  HomePageBloc(){
    changeFabState(true);
    changeSearchShow(false);
    changeSelectedLocation(NestedRoutes.notesPath);
    currentLocation = NestedRoutes.notesPath;
  }

  final _fabStateSubject = BehaviorSubject<bool>();
  final _showSearchSubject = BehaviorSubject<bool>();
  final _selectedLocationSubject = BehaviorSubject<String>();

  Stream<bool> get fabStateStream => _fabStateSubject.stream;
  Stream<bool> get showSearchStream => _showSearchSubject.stream;
  Stream<String> get selectedLocationStream => _selectedLocationSubject.stream;

  Function(bool) get changeFabState => _fabStateSubject.sink.add;
  Function(bool) get changeSearchShow => _showSearchSubject.sink.add;
  Function(String) get changeSelectedLocation => _selectedLocationSubject.sink.add;

  void changeFABState(bool isToShow) async{
    await changeFabState(isToShow);
  }

  void changeSearchState(bool isToShow) async{
    await changeSearchShow(isToShow);
  }

  void changeCurrentLocation(String location) async{
    currentLocation = location;
    await changeSelectedLocation(location);
  }

  @override
  void dispose() {
    _fabStateSubject.close();
    _showSearchSubject.close();
    _selectedLocationSubject.close();
  }
}
