

import 'package:flutter/foundation.dart';
import 'package:grabto/model/different_location_model.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/grabto_grab_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class GrabtoGrabRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GrabtoGrabModel> grabtoGrabApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-grapto-grab');
      return GrabtoGrabModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during GrabtoGrabRepo: $e');
      }
      rethrow;
    }
  }}