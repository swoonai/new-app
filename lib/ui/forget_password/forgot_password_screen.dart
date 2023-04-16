import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_flutter/ui/custom_widgets/copyright_text_widget.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text_field.dart';
import 'package:streamit_flutter/ui/forget_password/forgot_password_controller.dart';
import '../../main.dart';
import '../../utils/resources/Colors.dart';
import '../custom_widgets/custom_button.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  final controller = Get.put(ForgotPasswordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).viewPadding.top,
                bottom: 60),
            height: double.infinity,
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText('EA', color: Colors.white, fontSize: 38),
                    CustomText('Forgot Password?',
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 10),
                    CustomText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ',
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width: 40,
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ))),
                    SizedBox(height: 10),
                    Obx(() => CustomTextField<ForgotPasswordController>(
                          textController:
                              controller.controllerNewPassword.value,
                          hintText: 'New Password',
                          isPassword: true,
                          suffixWidget: Text(
                            'Show',
                            style: TextStyle(
                                color: hintColor,
                                fontSize: 14,
                                fontFamily: 'RobotoCondensed',
                                fontWeight: FontWeight.w300),
                          ),
                          isObSecure: controller.isNewPasswordObSecure.value,
                          onObSecureChanged: () {
                            controller.isNewPasswordObSecure.value =
                                !controller.isNewPasswordObSecure.value;
                          },
                        )),
                    SizedBox(height: 10),
                    Obx(() => CustomTextField<ForgotPasswordController>(
                          textController:
                              controller.controllerRepeatPassword.value,
                          hintText: 'Repeat Password',
                          suffixWidget: Text(
                            'Show',
                            style: TextStyle(
                                color: hintColor,
                                fontSize: 14,
                                fontFamily: 'RobotoCondensed',
                                fontWeight: FontWeight.w300),
                          ),
                          validator: (String? str) {
                            return controller
                                    .controllerRepeatPassword.value.text.isEmpty
                                ? language!.thisFieldIsRequired
                                : controller.controllerNewPassword.value.text !=
                                        controller
                                            .controllerRepeatPassword.value.text
                                    ? 'Password does not match'
                                    : null;
                          },
                          isObSecure: controller.isRepeatPasswordObSecure.value,
                          onObSecureChanged: () {
                            controller.isRepeatPasswordObSecure.value =
                                !controller.isRepeatPasswordObSecure.value;
                          },
                        )),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: 40,
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ))),
                    SizedBox(height: 10),
                    CustomButton('SAVE', onClick: () {
                      if (_formKey.currentState!.validate()) {}
                    })
                  ],
                ),
              ),
            ),
          ),
          CopyrightTextWidget(),
        ],
      ),
    );
  }
}
