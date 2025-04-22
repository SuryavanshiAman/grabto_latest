

import 'package:flutter/foundation.dart';
import 'package:grabto/model/different_location_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/grabto_grab_model.dart';
import 'package:grabto/model/recomended_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class RecomendedRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<RecomendedModel> recomendedApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/api-recomended-store');
      return RecomendedModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during recomendedApi: $e');
      }
      rethrow;
    }
  }}