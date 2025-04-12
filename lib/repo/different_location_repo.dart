


import 'package:flutter/foundation.dart';
import 'package:grabto/model/different_location_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../model/near_by_location_model.dart';

class DifferentLocationRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<DifferentLocationModel> differentLocationApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/nearby-places');
      return DifferentLocationModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during differentLocationApi: $e');
      }
      rethrow;
    }
  }
  Future<NearByLocationModel> nearByPlaces(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/find-nearby-places',data);
      return NearByLocationModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during find-nearby-places: $e');
      }
      rethrow;
    }
  }

}