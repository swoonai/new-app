import 'package:flutter/material.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onClick;
  final String? prefixIconPath;

  const CustomButton(this.text,
      {super.key, required this.onClick, this.prefixIconPath});

  @override
  Widget build(BuildContext context) {
    final textWidget = CustomText(
      text,
      color: Colors.black,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w400,
    );
    return ElevatedButton(
      onPressed: onClick,
      child: (prefixIconPath != null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(prefixIconPath ?? '', width: 24,height: 24,),
                SizedBox(width: 20),
                textWidget
              ],
            )
          : textWidget,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50)),
    );
  }
}
