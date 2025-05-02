


import 'package:flutter/foundation.dart';
import 'package:grabto/model/menu_data_model.dart';
import 'package:grabto/services/api.dart';
import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class MenuDataRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MenuDataModel> menuDataApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/api-menu-data',data );
      return MenuDataModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during menuDataApi: $e');
      }
      rethrow;
    }
  }

}