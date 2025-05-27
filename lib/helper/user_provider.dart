


import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/user_model.dart';
import 'package:flutter/material.dart';
class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;


  Future<void> fetchUserDetails() async {
    UserModel userData = await SharedPref.getUser();
    _user = userData;
    notifyListeners();
  }

  void updateUserDetails(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
