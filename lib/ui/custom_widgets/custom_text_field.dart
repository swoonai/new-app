import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../../utils/Constants.dart';
import '../../utils/resources/Colors.dart';

class CustomTextField<T> extends GetView<T> {
  final controller = Get.find<T>();
  final TextEditingController? textController;
  final String? hintText;
  bool? isObSecure;
  final Widget? suffixWidget;
  final bool isEmailPhone;
  final bool isEmail;
  final bool isPassword;
  final bool isRepeatPassword;
  final bool isPhone;
  final Function? onObSecureChanged;
  final String? Function(String? str)? validator;

  CustomTextField(
      {this.textController,
      this.hintText,
      this.suffixWidget,
      this.isObSecure,
      this.isEmailPhone = false,
      this.isEmail = false,
      this.isPassword = false,
      this.isRepeatPassword = false,
      this.isPhone = false, this.onObSecureChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w300),
      obscureText: isObSecure ?? false,
      inputFormatters:
          isPhone ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        counterText: '',
        suffix: suffixWidget != null
            ? InkWell(
                onTap: () {
                  onObSecureChanged!();
                },
                child: suffixWidget)
            : const SizedBox(),
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500)),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
        border: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
      ),

      validator: validator ?? (value) {
        if (value!.isEmpty) return language!.thisFieldIsRequired;
        if (isEmailPhone && !value.isDigit() && !value.validateEmail())
          return language!.invalidEmail;
        if (isEmail && !value.validateEmail()) return language!.invalidEmail;
        if (isPassword && value.length < passwordLength)
          return language!.passwordLengthShouldBeMoreThan6;
        return null;
      },

      maxLines: 1,
      // keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}
