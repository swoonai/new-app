import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text_field.dart';
import 'package:streamit_flutter/ui/otp/otp_screen.dart';
import 'package:streamit_flutter/ui/signin/signin_controller.dart';
import 'package:streamit_flutter/ui/user_selection/user_selection_screen.dart';

import '../../utils/Constants.dart';
import '../../utils/resources/Colors.dart';
import '../custom_widgets/copyright_text_widget.dart';
import '../custom_widgets/custom_button.dart';
import '../forget_password/forgot_password_screen.dart';
import '../otp/otp_binding.dart';
import '../signup/signup_binding.dart';
import '../signup/signup_screen.dart';

class SignInScreen extends GetView<SignInController> {
  final controller = Get.put(SignInController());
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
                    Image.asset('${imagePathPng}ea_white.png'),
                    // CustomText('EA', color: Colors.white, fontSize: 38),
                    SizedBox(height: 10),
                    CustomText(
                      'Sign In',
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      'Lorem ipsum dolor sit amet, consectetur adipis in elit. Maecenas vestibulum enim ut posuere.',
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w100,
                    ),
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
                    CustomTextField<SignInController>(
                        textController: controller.controllerEmail.value,
                        hintText: 'E-mail or Phone Number',
                        isEmailPhone: true),
                    SizedBox(height: 10),
                    Obx(() => CustomTextField<SignInController>(
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
                          "Don't have account?",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'RobotoCondensed',
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      SignUpScreen(),
                                ));
                          },
                          child: CustomText('Sign Up Now',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'RobotoCondensed',
                              isUnderline: true),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute<void>(
                    //             builder: (BuildContext context) =>
                    //                 ForgotPasswordScreen(),
                    //           ));
                    //     },
                    //     child: CustomText('Forgot Password?',
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w300,
                    //         fontFamily: 'RobotoCondensed',
                    //         isUnderline: true),
                    //   ),
                    // ),
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
                    CustomButton('LOGIN', onClick: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  UserSelectionScreen(),
                            ));
                      }
                    }),
                    SizedBox(height: 20),
                    CustomButton('LOG IN WITH GOOGLE',
                        prefixIconPath: '${imagePathPng}ic_google.png',
                        onClick: () {
                      controller.googleLogin(callback: (Widget w) {
                        w.launch(context);
                      });
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
