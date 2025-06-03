

import 'package:flutter/foundation.dart';
import 'package:grabto/model/get_flick_model.dart';
import 'package:grabto/model/like_model.dart';

import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../services/api.dart';

class LikeRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<LikeModel> likeApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/like',data );
      return LikeModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during likeApi: $e');
      }
      rethrow;
    }
  }}