import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserSelectionController extends GetxController {
  var list = [].obs;
  var prevIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    list.value = [
      {
        'name': 'Laura\nBernshtein',
        'profile_pic': 'image_1.png',
        'is_selected': true
      },
      {
        'name': 'Daniel\nFridman',
        'profile_pic': 'image_2.png',
        'is_selected': false
      },
      {
        'name': 'Zura\nMilchenko',
        'profile_pic': 'image_3.png',
        'is_selected': false
      },
      {
        'name': 'Maya\nLakoba',
        'profile_pic': 'image_4.png',
        'is_selected': false
      },
      {
        'name': 'Merab\nVacheishvili',
        'profile_pic': 'image_5.png',
        'is_selected': false
      }
    ];
  }
}
