import 'package:flutter/material.dart';

class AvailableConfiguration with ChangeNotifier{

  String? availableSubscription;
  String? addCartAvailable;

  setValue({String? subscription, String? addCart, }){
    availableSubscription = subscription;
    addCartAvailable = addCart;
    notifyListeners();
  }

}