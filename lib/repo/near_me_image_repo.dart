


import 'package:flutter/foundation.dart';
import 'package:grabto/model/near_me_image_model.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class NearMeImageRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<NearMeImageModel> nearMeImageApi() async {
    try {
      dynamic response =
      await _apiServices.getGetApiResponse('$BASE_URL/get-near-me');
      return NearMeImageModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during nearMeImageApi: $e');
      }
      rethrow;
    }
  }

}