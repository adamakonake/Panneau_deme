import 'package:flutter/material.dart';

class AuthPageService extends ChangeNotifier {

  int _index = 0;

  int get index => _index;

  void changeIndex(int index){
    _index = index;
    applyChange();
  }

  void applyChange(){
    notifyListeners();
  }
}