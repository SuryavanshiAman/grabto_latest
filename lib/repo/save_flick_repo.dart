

import 'package:flutter/foundation.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class SaveFlickRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> saveFlickApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/bookmark',data );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during saveFlickApi: $e');
      }
      rethrow;
    }
  }}