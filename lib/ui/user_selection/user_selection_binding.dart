import 'package:get/get.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';
import 'package:streamit_flutter/ui/signup/signup_controller.dart';
import 'package:streamit_flutter/ui/user_selection/user_selection_controller.dart';

class UserSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserSelectionController());
  }
}
