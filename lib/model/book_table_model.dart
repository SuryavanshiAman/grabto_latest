
class bookTableModel {
  List<Weekday>? weekday;

  bookTableModel({this.weekday});

  bookTableModel.fromJson(Map<String, dynamic> json) {
    if (json['weekday'] != null) {
      weekday = <Weekday>[];
      json['weekday'].forEach((v) {
        weekday!.add(new Weekday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weekday != null) {
      data['weekday'] = this.weekday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weekday {
  int? to5Id;
  int? t05StoreId;
  String? t05T04DayId;
  String? t05Status;
  String? t05Date;
  String? t04Weekday;
  List<Meals>? meals;

  Weekday(
      {this.to5Id,
        this.t05StoreId,
        this.t05T04DayId,
        this.t05Status,
        this.t05Date,
        this.t04Weekday,
        this.meals});

  Weekday.fromJson(Map<String, dynamic> json) {
    to5Id = json['to5_id'];
    t05StoreId = json['t05_store_id'];
    t05T04DayId = json['t05_t04_day_id'];
    t05Status = json['t05_status'];
    t05Date = json['t05_date'];
    t04Weekday = json['t04_weekday'];
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(new Meals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to5_id'] = this.to5Id;
    data['t05_store_id'] = this.t05StoreId;
    data['t05_t04_day_id'] = this.t05T04DayId;
    data['t05_status'] = this.t05Status;
    data['t05_date'] = this.t05Date;
    data['t04_weekday'] = this.t04Weekday;
    if (this.meals != null) {
      data['meals'] = this.meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meals {
  int? to6Id;
  int? t06StoreId;
  int? t06T04Id;
  int? t06T03Id;
  String? t06Status;
  String? t06Date;
  String? t03FoodType;
  List<Time>? time;

  Meals(
      {this.to6Id,
        this.t06StoreId,
        this.t06T04Id,
        this.t06T03Id,
        this.t06Status,
        this.t06Date,
        this.t03FoodType,
        this.time});

  Meals.fromJson(Map<String, dynamic> json) {
    to6Id = json['to6_id'];
    t06StoreId = json['t06_store_id'];
    t06T04Id = json['t06_t04_id'];
    t06T03Id = json['t06_t03_id'];
    t06Status = json['t06_status'];
    t06Date = json['t06_date'];
    t03FoodType = json['t03_food_type'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(new Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to6_id'] = this.to6Id;
    data['t06_store_id'] = this.t06StoreId;
    data['t06_t04_id'] = this.t06T04Id;
    data['t06_t03_id'] = this.t06T03Id;
    data['t06_status'] = this.t06Status;
    data['t06_date'] = this.t06Date;
    data['t03_food_type'] = this.t03FoodType;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Time {
  int? to2Id;
  int? t02StoreId;
  String? t02Day;
  int? t02FoodId;
  String? t02Time;
  int? t02Noofseats;
  String? t02Status;
  String? t02Date;
  String? t01Time;

  Time(
      {this.to2Id,
        this.t02StoreId,
        this.t02Day,
        this.t02FoodId,
        this.t02Time,
        this.t02Noofseats,
        this.t02Status,
        this.t02Date,
        this.t01Time});

  Time.fromJson(Map<String, dynamic> json) {
    to2Id = json['to2_id'];
    t02StoreId = json['t02_store_id'];
    t02Day = json['t02_day'];
    t02FoodId = json['t02_food_id'];
    t02Time = json['t02_time'];
    t02Noofseats = json['t02_noofseats'];
    t02Status = json['t02_status'];
    t02Date = json['t02_date'];
    t01Time = json['t01_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to2_id'] = this.to2Id;
    data['t02_store_id'] = this.t02StoreId;
    data['t02_day'] = this.t02Day;
    data['t02_food_id'] = this.t02FoodId;
    data['t02_time'] = this.t02Time;
    data['t02_noofseats'] = this.t02Noofseats;
    data['t02_status'] = this.t02Status;
    data['t02_date'] = this.t02Date;
    data['t01_time'] = this.t01Time;
    return data;
  }
}
