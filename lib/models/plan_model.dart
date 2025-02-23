import 'package:granth_flutter/utils/model_keys.dart';

class PlanModel2 {
  int? id;
  String? name;
  int? status;
  int? duration;
  num? price;

  PlanModel2({this.id, this.name, this.status, this.duration, this.price});

  factory PlanModel2.fromJson(Map<String, dynamic> json) {
    return PlanModel2(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      duration: json["duration"],
      price: json["price"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["status"] = this.status;
    data["duration"] = this.duration;
    data["price"] = this.price;
    
    return data;
  }
}

class PlanModel {
  bool? status;
  String? message;
  Data? data;

  PlanModel({this.status, this.message, this.data});

  PlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<PlanDetails>? yearlyPlans;
  List<PlanDetails>? monthlyPlans;

  Data({this.yearlyPlans, this.monthlyPlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['yearlyPlans'] != null) {
      yearlyPlans = <PlanDetails>[];
      json['yearlyPlans'].forEach((v) {
        yearlyPlans!.add(new PlanDetails.fromJson(v));
      });
    }
    if (json['monthlyPlans'] != null) {
      monthlyPlans = <PlanDetails>[];
      json['monthlyPlans'].forEach((v) {
        monthlyPlans!.add(new PlanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.yearlyPlans != null) {
      data['yearlyPlans'] = this.yearlyPlans!.map((v) => v.toJson()).toList();
    }
    if (this.monthlyPlans != null) {
      data['monthlyPlans'] = this.monthlyPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanDetails {
  int? id;
  String? name;
  int? status;
  int? duration;
  int? price;
  String? createdAt;
  String? updatedAt;
  MyPlan? myPlan;
  String? durationString;

  PlanDetails(
      {this.id,
        this.name,
        this.status,
        this.duration,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.myPlan,
        this.durationString});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    duration = json['duration'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    myPlan =
    json['myPlan'] != null ? new MyPlan.fromJson(json['myPlan']) : null;
    durationString = json['durationString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.myPlan != null) {
      data['myPlan'] = this.myPlan!.toJson();
    }
    data['durationString'] = this.durationString;
    return data;
  }
}

class MyPlan {
  int? price;
  String? duration;

  MyPlan({this.price, this.duration});

  MyPlan.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['duration'] = this.duration;
    return data;
  }
}
