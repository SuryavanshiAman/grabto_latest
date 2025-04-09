import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/different_location_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/repo/different_location_repo.dart';
import 'package:grabto/ui/different_location_screen.dart';

import '../helper/response/api_response.dart';
import '../model/near_by_location_model.dart';
import '../repo/filter_repo.dart';

class DifferentLocationViewModel with ChangeNotifier {
  final _locationRepo =DifferentLocationRepo();

  ApiResponse<DifferentLocationModel> locationList = ApiResponse.loading();

  setLocationList(ApiResponse<DifferentLocationModel> response) {
    locationList = response;
    notifyListeners();
  }

  Future<void>differentLocationApi(context) async {
    setLocationList(ApiResponse.loading());

    _locationRepo.differentLocationApi().then((value) {
      if (value.res == "success") {
        setLocationList(ApiResponse.completed(value));

      } else {
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setLocationList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }

  /// near by location
  final _nearByRepo =DifferentLocationRepo();

  ApiResponse<NearByLocationModel> nearByList = ApiResponse.loading();

  setNearByList(ApiResponse<NearByLocationModel> response) {
    nearByList = response;
    notifyListeners();
  }

  Future<void>nearByPlacesApi(context,dynamic name) async {
    setNearByList(ApiResponse.loading());
Map data={
  "name":name
};
    _nearByRepo.nearByPlaces(data).then((value) {
      if (value.res == "success") {
        setNearByList(ApiResponse.completed(value));
Navigator.push(context, MaterialPageRoute(builder: (context)=>DifferentLocationScreen(name:name)));
      } else {
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setNearByList(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
