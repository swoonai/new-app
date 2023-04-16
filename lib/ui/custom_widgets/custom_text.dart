import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? alignment;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? isUnderline;

  const CustomText(
      this.text,
      {super.key,
      this.color,
      this.alignment,
      this.fontFamily,
      this.fontWeight,
      this.fontSize,
      this.isUnderline});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: alignment ?? TextAlign.center,
        style: TextStyle(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            color: color ?? Colors.black,
            fontSize: fontSize ?? 14,
            decoration: (isUnderline ?? false)
                ? TextDecoration.underline
                : TextDecoration.none));
  }
}
