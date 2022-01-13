


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BurbleService extends ChangeNotifier{

  bool _updateIcon= false;

  bool get update=>_updateIcon;


  set update(bool data){
    _updateIcon = data;
    notifyListeners();
  }


}