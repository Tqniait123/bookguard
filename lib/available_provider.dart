import 'package:flutter/material.dart';

class AvailableSubscription with ChangeNotifier{

  String? availableSubscription;

  setValue(String? val){
    availableSubscription = val;
    notifyListeners();
  }

}