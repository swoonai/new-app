import 'package:get/get.dart';
import 'package:streamit_flutter/ui/otp/otp_controller.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
