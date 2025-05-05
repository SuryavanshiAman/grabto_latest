


import 'package:flutter/foundation.dart';
import 'package:grabto/services/api.dart';
import '../helper/network/base_api_services.dart';
import '../helper/network/network_api_services.dart';
import '../model/get_wallet_model.dart';

class GetWalletRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetWalletModel> getWalletApi(dynamic data) async {
    try {
      print("QQQQ$data");
      dynamic response =
      await _apiServices.getPostApiResponse('$BASE_URL/get-wallet-amount',data );
      return GetWalletModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during getWalletApi: $e');
      }
      rethrow;
    }
  }

}