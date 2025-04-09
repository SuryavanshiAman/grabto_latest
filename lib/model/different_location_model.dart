class DifferentLocationModel {
  String? res;
  String? msg;
  List<Data>? data;
  List<Data>? data1; // Use the same Data class

  DifferentLocationModel({this.res, this.msg, this.data, this.data1});

  DifferentLocationModel.fromJson(Map<String, dynamic> json) {
    res = json['res'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['data1'] != null) {
      data1 = <Data>[];
      json['data1'].forEach((v) {
        data1!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['res'] = res;
    jsonData['msg'] = msg;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (data1 != null) {
      jsonData['data1'] = data1!.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class Data {
  String? localityName;

  Data({this.localityName});

  Data.fromJson(Map<String, dynamic> json) {
    localityName = json['locality_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'locality_name': localityName,
    };
  }
}
