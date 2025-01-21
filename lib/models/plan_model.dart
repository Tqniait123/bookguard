import 'package:granth_flutter/utils/model_keys.dart';

class PlanModel {
  int? id;
  String? name;
  int? status;
  int? duration;
  num? price;

  PlanModel({this.id, this.name, this.status, this.duration, this.price});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
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
