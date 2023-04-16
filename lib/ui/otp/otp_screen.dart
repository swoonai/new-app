import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:streamit_flutter/ui/custom_widgets/copyright_text_widget.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';
import 'package:streamit_flutter/ui/otp/otp_controller.dart';

import '../../utils/resources/Colors.dart';

class OtpScreen extends GetView<OtpController> {
  final String? emailPhone;
  final controller = Get.put(OtpController());

  OtpScreen({this.emailPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).viewPadding.top,
                bottom: 60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150),
                  CustomText('EA', color: Colors.white, fontSize: 38),
                  SizedBox(height: 20),
                  CustomText(
                    'SMS VERIFICATION CODE OTP',
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod\n${emailPhone ?? ''}',
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                  ),
                  SizedBox(height: 35),
                  OTPTextField(
                    length: 6,
                    spaceBetween: 8,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: (MediaQuery.of(context).size.width - 80) / 6,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w400),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 0,
                    otpFieldStyle: OtpFieldStyle(
                      borderColor: colorPrimary,
                      enabledBorderColor: Colors.grey.shade500,
                      errorBorderColor: colorPrimary,
                      focusBorderColor: colorPrimary,
                    ),
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                    },
                  ),
                  SizedBox(height: 25),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              'Please add your confirmation code above, if you don\'t receive.\nPlease click on the link and we will ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w100)),
                      TextSpan(
                          text: 'send again',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.underline)),
                    ]),
                  )
                  // CustomText(
                  //     'Please add your confirmation code above, if you don\'t receive.\nPlease click on the link and we will send again',
                  //   color: Colors.white,
                  //   fontSize: 12,
                  //   fontFamily: 'Roboto',
                  //   fontWeight: FontWeight.w100),
                ],
              ),
            ),
          ),
          CopyrightTextWidget(),
        ],
      ),
    );
  }
}
