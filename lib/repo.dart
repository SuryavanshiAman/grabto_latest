


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/services/api.dart';

import 'helper/network/base_api_services.dart';
import 'helper/network/network_api_services.dart';

class FilterRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<FilteredDataModel> filterApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/filter-Stores',data );
      return FilteredDataModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during filterApi: $e');
      }
      rethrow;
    }
  }

}