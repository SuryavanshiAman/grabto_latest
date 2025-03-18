
import 'package:flutter/cupertino.dart';

class Address with ChangeNotifier{

  String _area='';

  String get area => _area;

  setArea(String value) {
    _area = value;
    notifyListeners();
  }
  String _address='';

  String get address => _address;

  setAddress(String value) {
    _address = value;
    notifyListeners();
  }

}