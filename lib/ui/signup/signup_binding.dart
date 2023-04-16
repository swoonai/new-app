import 'package:get/get.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';
import 'package:streamit_flutter/ui/signup/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
