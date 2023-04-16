import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {

  final controllerNewPassword = TextEditingController().obs;
  final controllerRepeatPassword = TextEditingController().obs;
  final isNewPasswordObSecure = true.obs;
  final isRepeatPasswordObSecure = true.obs;
}