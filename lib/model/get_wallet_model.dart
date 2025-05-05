class GetWalletModel {
  String? res;
  String? message;
  dynamic? walletAmount;
  dynamic? deductAmount;

  GetWalletModel(
      {this.res, this.message, this.walletAmount, this.deductAmount});

  GetWalletModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    message = json['message'];
    walletAmount = json['wallet_amount'];
    deductAmount = json['deduct_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res'] = this.res;
    data['message'] = this.message;
    data['wallet_amount'] = this.walletAmount;
    data['deduct_amount'] = this.deductAmount;
    return data;
  }
}
