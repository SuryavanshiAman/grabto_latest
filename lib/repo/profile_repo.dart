


import 'package:flutter/foundation.dart';
import 'package:grabto/model/filtered_data_model.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/get_post_model.dart';
import 'package:grabto/model/pofile_model.dart';
import 'package:grabto/services/api.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';

class ProfileRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ProfileModel> profileApi(dynamic data) async {
    try {
      print("QQQQ$data");
      print("🎉🎉🎉");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/user_details',data );
      return ProfileModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during profileApi: $e');
      }
      rethrow;
    }
  }

}