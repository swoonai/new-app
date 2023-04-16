import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text_field.dart';
import 'package:streamit_flutter/ui/forget_password/forgot_password_screen.dart';
import 'package:streamit_flutter/ui/signin/signin_binding.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';
import 'package:streamit_flutter/ui/signin/signin_screen.dart';
import 'package:streamit_flutter/utils/Constants.dart';

import '../../utils/resources/Colors.dart';
import '../custom_widgets/copyright_text_widget.dart';
import '../custom_widgets/custom_button.dart';
import '../otp/otp_screen.dart';
import 'signup_controller.dart';

class SignUpScreen extends GetView<SignUpController> {
  final controller = Get.put(SignUpController());
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
                    // SvgPicture.asset('${imagePathSvg}ea_white.svg'),
                    SizedBox(height: 50),
                    Obx(
                      () => Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)),
                        child: controller.imageFile.value.path.isEmpty
                            ? Stack(
                                children: [
                                  Center(
                                      child: CustomText('EA',
                                          color: Colors.white, fontSize: 38)),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: greyBgColor,
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: InkWell(
                                        onTap: () {
                                          controller.pickImage();
                                        },
                                        child: SvgPicture.asset(
                                            '${imagePathSvg}camera.svg'),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(200.0),
                                    child: Image.file(
                                      controller.imageFile.value,
                                      fit: BoxFit.fill,
                                      height: 130,
                                      width: 130,
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: greyBgColor,
                                        border:
                                        Border.all(color: Colors.white)),
                                    child: InkWell(
                                      onTap: () {
                                        controller.pickImage();
                                      },
                                      child: SvgPicture.asset(
                                          '${imagePathSvg}camera.svg'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomText('Sign Up',
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
                    CustomTextField<SignUpController>(
                      textController: controller.controllerName.value,
                      hintText: 'Name, Last name',
                    ),
                    SizedBox(height: 10),
                    CustomTextField<SignUpController>(
                        textController: controller.controllerPhoneNo.value,
                        hintText: 'Phone Number',
                        isPhone: true),
                    SizedBox(height: 10),
                    CustomTextField<SignUpController>(
                      textController: controller.controllerEmail.value,
                      hintText: 'E-mail Address',
                      isEmail: true,
                    ),
                    SizedBox(height: 10),
                    CustomTextField<SignUpController>(
                      textController: controller.controllerCountry.value,
                      hintText: 'Country',
                    ),
                    SizedBox(height: 10),
                    Obx(() => CustomTextField<SignUpController>(
                          textController: controller.controllerPassword.value,
                          hintText: 'Password',
                          isPassword: true,
                          suffixWidget: Text(
                            'Show',
                            style: TextStyle(
                                color: hintColor,
                                fontSize: 14,
                                fontFamily: 'RobotoCondensed',
                                fontWeight: FontWeight.w300),
                          ),
                          isObSecure: controller.isPasswordObSecure.value,
                          onObSecureChanged: () {
                            controller.isPasswordObSecure.value =
                                !controller.isPasswordObSecure.value;
                          },
                        )),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CustomText(
                          'Have an account?',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'RobotoCondensed',
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute<void>(
                            //       builder: (BuildContext context) =>
                            //           SignInScreen(),
                            //     ));
                          },
                          child: CustomText('Sign In',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'RobotoCondensed',
                              isUnderline: true),
                        ),
                      ],
                    ),
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
                    CustomButton(
                      'SIGN UP',
                      onClick: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => OtpScreen(
                                    emailPhone:
                                    controller.controllerPhoneNo.value.text),
                              ));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute<void>(
                          //       builder: (BuildContext context) =>
                          //           ForgotPasswordScreen(),
                          //     ));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          CopyrightTextWidget()
        ],
      ),
    );
  }
}
