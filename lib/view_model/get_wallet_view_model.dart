import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/get_wallet_model.dart';
import 'package:grabto/repo/get_wallet_repo.dart';
import '../helper/response/api_response.dart';

class GetWalletViewModel with ChangeNotifier {
  final _getWalletRepo = GetWalletRepo();

  ApiResponse<GetWalletModel> getWallet = ApiResponse.loading();

  setGetWallet(ApiResponse<GetWalletModel> response) {
    getWallet = response;
    notifyListeners();
  }
  int _finalAmount=0;

  int get finalAmount => _finalAmount;

  setFinalAmount(int value) {
    _finalAmount = value;
    notifyListeners();
  }

  Future<void> getWalletApi(context, dynamic id, dynamic amount) async {
    setGetWallet(ApiResponse.loading());
    Map data = {
      "user_id":id.toString(),
      "amount":amount.toString()
    };
    print(data);
    print("potaaaaa");
    _getWalletRepo.getWalletApi(data).then((value) {
      if (value.res == "success") {
        setGetWallet(ApiResponse.completed(value));
        print(amount);
        print(getWallet.data?.deductAmount);
        setFinalAmount(
            (double.parse(amount?.toString() ?? "0") - (getWallet.data?.deductAmount ?? 0)).toInt()
        );
        print(finalAmount);

        print("finalAmount");
      } else {
        setGetWallet(ApiResponse.completed(value));
        if (kDebugMode) {
          print('value:');
        }
      }
    }).onError((error, stackTrace) {
      setGetWallet(ApiResponse.error(error.toString()));
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
