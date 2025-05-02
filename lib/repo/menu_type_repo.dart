


import 'package:flutter/foundation.dart';
import 'package:grabto/model/menu_data_model.dart';
import 'package:grabto/model/menu_type_model.dart';
import 'package:grabto/services/api.dart';
import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class MenuTypeRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MenuTypeModel> menuTypeApi(dynamic data) async {

    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/api-menu-type',data );
      return MenuTypeModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during menuTypeApi: $e');
      }
      rethrow;
    }
  }

}