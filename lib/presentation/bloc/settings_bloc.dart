import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class SettingsBloC extends BaseBloc{
  final int initialIndex;

  SettingsBloC(this.initialIndex){
    changeColor(initialIndex);
  }

  final _selectedColorIndex = BehaviorSubject<int>();

  Stream<int> get selectedColorStream => _selectedColorIndex.stream;

  Function(int) get changeSelectedColor => _selectedColorIndex.sink.add;

  void changeColor(int index) async{
    await changeSelectedColor(index);
  }

  @override
  void dispose() {
    _selectedColorIndex.close();
  }
}
