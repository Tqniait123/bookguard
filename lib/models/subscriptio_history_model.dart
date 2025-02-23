import 'package:granth_flutter/models/plan_model.dart';

class SubscriptionsHistoryModel {
  bool? status;
  List<SubscriptionsHistory>? subscriptionsHistory;
  ActiveSubscription? activeSubscription;

  SubscriptionsHistoryModel(
      {this.status, this.subscriptionsHistory, this.activeSubscription});

  SubscriptionsHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['subscriptionsHistory'] != null) {
      subscriptionsHistory = <SubscriptionsHistory>[];
      json['subscriptionsHistory'].forEach((v) {
        subscriptionsHistory!.add(new SubscriptionsHistory.fromJson(v));
      });
    }
    activeSubscription = json['activeSubscription'] != null
        ? new ActiveSubscription.fromJson(json['activeSubscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.subscriptionsHistory != null) {
      data['subscriptionsHistory'] =
          this.subscriptionsHistory!.map((v) => v.toJson()).toList();
    }
    if (this.activeSubscription != null) {
      data['activeSubscription'] = this.activeSubscription!.toJson();
    }
    return data;
  }
}

class SubscriptionsHistory {
  int? id;
  int? userId;
  int? planId;
  int? duration;
  String? from;
  String? to;
  int? price;
  String? createdAt;
  String? updatedAt;
  bool? mySubscription;
  String? durationString;
  PlanModel2? plan;

  SubscriptionsHistory(
      {this.id,
        this.userId,
        this.planId,
        this.duration,
        this.from,
        this.to,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.mySubscription,
        this.durationString,
        this.plan});

  SubscriptionsHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    duration = json['duration'];
    from = json['from'];
    to = json['to'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mySubscription = json['mySubscription'];
    durationString = json['durationString'];
    plan = json['plan'] != null ? new PlanModel2.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['duration'] = this.duration;
    data['from'] = this.from;
    data['to'] = this.to;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['mySubscription'] = this.mySubscription;
    data['durationString'] = this.durationString;
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}

class ActiveSubscription {
  int? id;
  int? userId;
  int? planId;
  int? duration;
  String? from;
  String? to;
  int? price;
  String? createdAt;
  String? updatedAt;
  String? durationString;
  PlanModel2? plan;

  ActiveSubscription(
      {this.id,
        this.userId,
        this.planId,
        this.duration,
        this.from,
        this.to,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.durationString,
        this.plan});

  ActiveSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    duration = json['duration'];
    from = json['from'];
    to = json['to'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    durationString = json['durationString'];
    plan = json['plan'] != null ? new PlanModel2.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['duration'] = this.duration;
    data['from'] = this.from;
    data['to'] = this.to;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['durationString'] = this.durationString;
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}