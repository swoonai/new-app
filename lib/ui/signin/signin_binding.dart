import 'package:get/get.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
